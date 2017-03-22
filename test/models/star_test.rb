# frozen_string_literal: true
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

  test 'updates star count column on resource' do
    assert_difference(-> { @starrable.reload.star_count }, 1) { toggle_star }
    assert_difference(-> { @starrable.reload.star_count }, -1) { toggle_star }
  end

  def toggle_star(user: @user)
    @starrable.stars.toggle user.id
  end

  def star_exists?
    Star.exists? starrable_type: @starrable.model_name.name, starrable_id: @starrable.id, user_id: @user.id
  end
end
