# frozen_string_literal: true

module ImagesHelper
  IMAGE_SORTS_CONSTRAINT = /newest|oldest|popular|undiscovered/

  IMAGE_SORTS = {
    'newest'       => %i(created_at desc),
    'oldest'       => %i(created_at asc),
    'popular'      => %i(stars desc),
    'undiscovered' => %i(stars asc)
  }.freeze

  IMAGE_SORT_LABELS = {
    'newest'       => 'Newest first',
    'oldest'       => 'Oldest first',
    'popular'      => 'Popular',
    'undiscovered' => 'Undiscovered'
  }.freeze

  def image_sort
    sort = params[:sort] || 'newest'
    IMAGE_SORTS[sort]
  end

  def image_sort_labels
    sort = params[:sort] || 'newest'
    yield IMAGE_SORT_LABELS[sort], IMAGE_SORT_LABELS.except(sort)
  end
end
