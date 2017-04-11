# frozen_string_literal: true
require 'test_helper'

class Admin::ReportsControllerTest < ActionController::TestCase
  test 'listing reports' do
    @admin = create(:user_admin)
    @report = create(:report_on_image)

    sign_in @admin

    get :index

    assert_equal [@report], assigns(:reports)
  end

  test 'resolving reports' do
    @admin = create(:user_admin)
    @report = create(:report_on_image)

    sign_in @admin

    refute @report.resolved?

    post :resolve, params: { id: @report.id }

    assert_redirected_to admin_reports_path

    assert @report.reload.resolved?
    assert_equal @admin, @report.resolved_by
  end
end
