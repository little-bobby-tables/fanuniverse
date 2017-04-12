# frozen_string_literal: true
require 'test_helper'

class ImageMergingJobTest < ActiveJob::TestCase
  test 'sets merged_into_id' do
    @source, @target = create_list :image, 2

    ImageMergingJob.perform_now @source.id, @target.id

    assert_equal @target.id, @source.reload.merged_into_id
  end

  test 'migrates stars and comments' do
    @user = create :user
    @source, @target = create_list :image, 2

    all_stars = 5.times.map do
      @source.stars.create! user: @user
    end + 2.times.map do
      @target.stars.create! user: @user
    end

    all_comments = 5.times.map do |n|
      @source.comments.create! body: "test#{n}", author: @user
    end + 2.times.map do |n|
      @target.comments.create! body: "test-target#{n}", author: @user
    end

    ImageMergingJob.perform_now @source.id, @target.id
    @target.reload

    assert_equal all_stars.count, @target.star_count
    assert_equal all_stars.sort, @target.stars.sort

    assert_equal all_comments.count, @target.comment_count
    assert_equal all_comments.sort, @target.comments.sort
  end
end
