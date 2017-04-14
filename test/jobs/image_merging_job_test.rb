# frozen_string_literal: true
require 'test_helper'

class ImageMergingJobTest < ActiveJob::TestCase
  setup do
    @source, @target = create_list :image, 2
  end

  test 'sets merged_into_id' do
    ImageMergingJob.perform_now @source.id, @target.id

    assert_equal @target.id, @source.reload.merged_into_id
  end

  test 'migrates tags' do
    tags_on_both = create_list :tag, 2
    tags_on_source = create_list :tag, 2
    tags_on_target = create_list :tag, 2

    @source.tag_names += (tags_on_both + tags_on_source).map(&:name)
    @target.tag_names += (tags_on_both + tags_on_target).map(&:name)

    [@source, @target].each(&:save)

    ImageMergingJob.perform_now @source.id, @target.id

    [@source, @target].each(&:reload)

    (tags_on_both + tags_on_source + tags_on_target).map(&:reload).each do |t|
      assert_includes @target.tag_names, t.name
      assert_equal 1, t.image_count
    end

    (tags_on_both + tags_on_source).each do |t|
      assert_includes @source.tag_names, t.name
    end
  end

  test 'migrates comments' do
    @user = create :user

    all_comments = 5.times.map do |n|
      @source.comments.create! body: "test#{n}", author: @user
    end + 2.times.map do |n|
      @target.comments.create! body: "test-target#{n}", author: @user
    end

    ImageMergingJob.perform_now @source.id, @target.id
    @target.reload

    assert_equal all_comments.count, @target.comment_count
    assert_equal all_comments.sort, @target.comments.sort
  end

  test 'migrates stars' do
    @user1, @user2 = create_list :user, 2

    [@user1, @user2].each { |u| [@source, @target].each { |i| i.stars.create! user: u } }

    ImageMergingJob.perform_now @source.id, @target.id
    @target.reload

    assert_equal 2, @target.star_count
    assert_equal [@user1, @user2].sort, @target.stars.map(&:user).sort
  end
end
