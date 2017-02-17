class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def index
    sort_field = params.fetch :sf, :created_at
    sort_direction = params.fetch :sd, :desc
    @images = search_images do |s|
      s.sort_by sort_field, sort_direction
    end
  rescue Elasticfusion::Search::SearchError => @search_error
  end

  def show
  end

  def new
    @image = Image.new
  end

  def edit
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
    if @image.update(image_params)
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @image.destroy
    redirect_to images_url, notice: 'Image was successfully destroyed.'
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
    params.require(:image).permit(:image, :tags)
  end
end
