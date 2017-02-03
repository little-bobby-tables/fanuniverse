class Api::RatingStarsController < ApplicationController
  def toggle
    head(:forbidden) and return unless user_signed_in?
    head(:not_found) and return unless Image.exists? id: params[:resource_id]

    RatingStar.toggle(user_id: current_user.id, resource_id: params[:resource_id])

    render json: { stars: Image.where(id: params[:resource_id]).pluck(:stars).first }
  end
end
