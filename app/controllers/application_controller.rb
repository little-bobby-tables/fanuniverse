class ApplicationController < ActionController::Base
  include JsDatastore

  protect_from_forgery with: :exception

  before_action :set_permitted_parameters_for_devise, if: :devise_controller?

  protected

  def paginate(resource)
    page = params[:page].to_i
    per_page = params[:per_page].to_i
    per_page = 20 unless per_page.between? 1, 50
    resource.page(page).per(per_page)
  end

  def set_permitted_parameters_for_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: User::ALLOWED_PARAMETERS)
  end
end
