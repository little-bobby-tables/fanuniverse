# frozen_string_literal: true

module ImagesHelper
  IMAGE_SORTS = { %w(created_at desc) => 'Newest first',
                  %w(created_at asc) => 'Oldest first',
                  %w(stars desc) => 'Popular',
                  %w(stars asc) => 'Undiscovered' }.freeze

  def image_sort
    field = params[:sf] || 'created_at'
    direction = params[:sd] || 'desc'
    current_sort = IMAGE_SORTS.keys.detect { |sort| sort == [field, direction] }
    yield IMAGE_SORTS[current_sort], IMAGE_SORTS.except(current_sort)
  end
end
