module JsDatastore
  extend ActiveSupport::Concern

  included do
    helper_method :js_data
  end

  def js_data
    @js_data ||= default_js_data
  end

  private

  def default_js_data
    {}
  end
end
