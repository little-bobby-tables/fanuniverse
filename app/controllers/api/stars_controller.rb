class Api::StarsController < ApplicationController
  def toggle
    type, id = params.values_at(:starrable_type, :starrable_id)

    head :forbidden and return unless user_signed_in?
    head :bad_request and return if type.blank? || id.blank?

    status = Star.toggle(type: type, id: id, user_id: current_user.id)
    if status
      new_star_count = type.constantize.where(id: id).pluck(:star_count).first
      render json: { stars: new_star_count, status: status }
    else
      head :bad_request
    end
  end
end
