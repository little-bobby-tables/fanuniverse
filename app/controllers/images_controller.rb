class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :history]

  def index
    sort_field = params.fetch :sf, :created_at
    sort_direction = params.fetch :sd, :desc
    @images = search_images do |s|
      s.sort_by sort_field, sort_direction
      s.scope :processed
    end
  rescue Elasticfusion::Search::SearchError => @search_error
  end

  def show
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

  def destroy
    @image.destroy
    redirect_to images_url, notice: 'Image was successfully destroyed.'
  end

  def history
  end

  private

  def search_images(&block)
    query = params[:q].presence
    search = if query
      Image.search_by_query(query, &block)
    else
      Image.custom_search(&block)
    end
    paginate(search).records
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:image, :remote_image_url, :tags, :source)
  end
end
