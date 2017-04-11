require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test 'registered users can submit reports' do
    @user = create(:user)
    @reportable = create(:image)
    @reportable_type = @reportable.model_name.name

    sign_in @user

    assert_difference -> { Report.count } do
      post :create, params: { report: { body: 'test report' },
                              reportable_type: @reportable_type,
                              reportable_id: @reportable.id }
    end

    assert Report.exists? reportable: @reportable, body: 'test report',
                          reported_by: @user
  end

  test 'users cannot see or resolve reports' do
    @user = create(:user)
    @report = create(:report_on_image)

    sign_in @user

    get :index

    assert_response :forbidden

    post :resolve, params: { id: @report.id }

    assert_response :forbidden
  end

  test 'administrators can see reports' do
    @admin = create(:user_admin)
    @report = create(:report_on_image)

    sign_in @admin

    get :index

    assert_equal [@report], assigns(:reports)
  end

  test 'administrators can resolve reports' do
    @admin = create(:user_admin)
    @report = create(:report_on_image)

    sign_in @admin

    refute @report.resolved?

    post :resolve, params: { id: @report.id }

    assert @report.reload.resolved?
    assert_equal @admin, @report.resolved_by
  end
end
