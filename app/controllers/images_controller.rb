class ImagesController < ApplicationController
  include StarrableResource

  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def index
    @images = Image.all
    load_stars @images
  end

  def show
    load_stars [@image]
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

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:image, :tags)
  end
end
