require 'test_helper'

class StarTest < ActiveSupport::TestCase
  setup do
    @starrable = create(:image)
    @user = create(:user)
  end

  test 'toggles stars for given resource and user' do
    assert_equal :added, toggle_star
    assert star_exists?

    assert_equal :removed, toggle_star
    refute star_exists?
  end

  test 'validates star creation' do
    assert_nil toggle_star(type: 'RandomType')
    refute Star.exists? starrable_type: 'RandomType'

    assert_nil toggle_star(id: 33)
    refute Star.exists? starrable_id: 33
  end

  test 'updates star count column on resource' do
    assert_difference(->{ @starrable.reload.star_count }, 1) { toggle_star }
    assert_difference(->{ @starrable.reload.star_count }, -1) { toggle_star }
  end

  test 'returns stars hash for given user and resources' do
    resources = [@starrable] + create_list(:image, 2)
    resources.each { |res| toggle_star(type: res.model_name.name, id: res.id) }

    assert_equal({ starrable_type => resources.map(&:id)},
                 Star.starred_hash(user: @user, resources_of_single_type: resources))

    toggle_star
    assert_equal({},
                 Star.starred_hash(user: @user, resources_of_single_type: [@starrable]))
  end

  test 'returns user ids for given resource' do
    @users = [@user, create(:user)]
    @users.each { |u| toggle_star(user: u) }

    assert_equal @users.map(&:id), Star.starred_by_ids(@starrable)
  end

  def toggle_star(type: starrable_type, id: @starrable.id, user: @user)
    Star.toggle type: type, id: id, user_id: user.id
  end

  def star_exists?
    Star.exists? starrable_type: starrable_type, starrable_id: @starrable.id, user_id: @user.id
  end

  def starrable_type
    @starrable.model_name.name
  end
end
