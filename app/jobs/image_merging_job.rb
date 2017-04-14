# frozen_string_literal: true
class ImageMergingJob < ApplicationJob
  queue_as :low

  def perform(id, target_id)
    @source = Image.find(id)
    @target = Image.find(target_id)

    merge
    move_tags
    move_stars
    move_comments
    update_counter_caches
    reindex
  end

  def merge
    @source.update_columns merged_into_id: @target.id
  end

  def move_tags
    @target.tag_names += @source.tag_names
    @target.save

    Tag.where(name: @source.tag_names).update_all 'image_count = image_count - 1'
  end

  def move_stars
    @source.stars.where.not(user_id: @target.stars.select(:user_id))
      .update_all starrable_id: @target.id
  end

  def move_comments
    @source.comments.update_all commentable_id: @target.id
  end

  def update_counter_caches
    Image.reset_counters @target.id, :stars, :comments
  end

  def reindex
    @source.reload.reindex_now
    @target.reload.reindex_now
  end
end
