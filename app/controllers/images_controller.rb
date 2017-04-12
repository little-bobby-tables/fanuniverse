# frozen_string_literal: true
class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :history, :navigate]

  def index
    @images = paginate(image_search.perform).records
  rescue Elasticfusion::Search::SearchError => @search_error
  end

  def show
    redirect_to image_path(@image.merged_into_id) if @image.merged_into_id
  end

  def new
    @image = Image.new

    use_content_security_policy_named_append :base64_image_preview
  end

  def edit
    authorize! :edit, @image
  end

  def create
    @image = Image.new(image_params.merge(suggested_by: current_user))

    if @image.save
      redirect_to @image, notice: 'Image was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :edit, @image
    # tag_cache is a workaround for concurrency issues like
    # two users editing tags at the same time leading to the last user to submit removing tags added by the first one.
    tags, tag_cache = params.require(:image).values_at(:tags, :tag_cache)
    @image.tags.update(tags, compare_against: tag_cache) if tags.present? && tag_cache.present?

    @image.assign_attributes(params.require(:image).permit(:source))

    if @image.save
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render :edit
    end
  end

  def history
  end

  def navigate
    target = if params[:direction] == 'next'
      image_search.next_record(@image)
    elsif params[:direction] == 'previous'
      image_search.previous_record(@image)
    end
    target ||= @image

    redirect_to image_url(target, params.permit(:q, :sort))
  end

  private

  def image_search
    query = params[:q].presence
    sort_field, sort_direction = *helpers.image_sort

    Image.custom_search(query) do |s|
      s.scope :visible
      s.sort_by sort_field, sort_direction
      s.ensure_deterministic_order_with_unique_field :id
    end
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:image, :remote_image_url, :tags, :source)
  end
end
