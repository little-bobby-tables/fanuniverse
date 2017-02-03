class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_permitted_parameters_for_devise, if: :devise_controller?

  protected

  def set_permitted_parameters_for_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: User::ALLOWED_PARAMETERS)
  end
end
