require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'returns 404 for unknown pages' do
    get '/some_unknown_page'
    assert_response :not_found
  end

  test 'renders known pages' do
    PagesController::PAGES.each do |page|
      get "/#{page}"
      assert_response :success
    end
  end
end
