class Api::StarsController < ApplicationController
  before_action :load_starrable

  def toggle
    authorize! :star, @starrable

    status = @starrable.stars.toggle(current_user.id)
    new_star_count = @starrable.instance_pluck(:star_count).first

    @starrable.reindex_later if @starrable.respond_to?(:reindex_later)

    render json: { stars: new_star_count, status: status }
  end

  private

  def load_starrable
    type = Star::STARRABLE.detect { |type| params[:starrable_type] == type }
    head :bad_request and return unless type

    @starrable = type.constantize.find(params[:starrable_id])
  end
end
