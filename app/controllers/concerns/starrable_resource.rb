module StarrableResource
  def load_stars(resources)
    if user_signed_in?
      js_data[:stars] = Star.resource_ids_with_stars(user: current_user, resources: resources)
    end
  end
end
