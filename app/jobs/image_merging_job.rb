# frozen_string_literal: true
class ImageMergingJob < ApplicationJob
  queue_as :low

  def perform(id, target_id)
    @source = Image.find(id)
    @target = Image.find(target_id)

    @source.update_columns merged_into_id: @target.id

    # Migrate stars and comments
    @source.stars
      .update_all starrable_id:   @target.id
    @source.comments
      .update_all commentable_id: @target.id

    # Reset counter caches
    Image.reset_counters @target.id, :stars, :comments

    # Reindex
    @source.reload.reindex_now
    @target.reload.reindex_now
  end
end
