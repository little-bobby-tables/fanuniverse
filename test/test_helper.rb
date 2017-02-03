ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end
