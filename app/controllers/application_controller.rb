class ApplicationController < ActionController::Base
  include JsDatastore

  protect_from_forgery with: :exception

  before_action :set_permitted_parameters_for_devise, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: -> { render_404 }
  rescue_from Corral::AccessDenied, with: -> { render_404 api_status: :forbidden }

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

  private

  def render_404(api_status: :not_found)
    respond_to do |format|
      format.html { render file: 'public/404.html', layout: false, status: :not_found }
      format.all { head api_status }
    end
  end
end
