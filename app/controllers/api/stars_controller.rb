class Api::StarsController < ApplicationController
  def toggle
    head(:forbidden) and return unless user_signed_in?
    head(:not_found) and return unless Image.exists? id: params[:resource_id]

    status = Star.toggle(user_id: current_user.id, resource_id: params[:resource_id])
    new_star_count = Image.where(id: params[:resource_id]).pluck(:stars).first

    render json: { stars: new_star_count, status: status }
  end
end
