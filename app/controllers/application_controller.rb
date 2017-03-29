# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :set_permitted_parameters_for_devise, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: -> { render_40x(:not_found) }
  rescue_from Corral::AccessDenied, with: -> { render_40x(:forbidden) }

  def render_40x(status = :not_found)
    use_content_security_policy_named_append :error_page

    respond_to do |format|
      format.html { render file: 'public/404.html', layout: false, status: status }
      format.all { head status }
    end
  end

  protected

  def paginate(resource)
    @page = params[:page].to_i
    @per_page = params[:per_page].to_i
    @per_page = 12 unless @per_page.between? 1, 50
    resource.page(@page).per(@per_page)
  end

  def set_permitted_parameters_for_devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: User::ALLOWED_PARAMETERS)
  end
end
