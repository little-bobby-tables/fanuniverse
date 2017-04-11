require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    @reportable = create(:image)
    @reportable_type = @reportable.model_name.name
  end

  test 'registered users can submit reports' do
    sign_in @user

    assert_difference -> { Report.count } do
      post :create, params: { report: { body: 'test report' },
                              reportable_type: @reportable_type,
                              reportable_id: @reportable.id }
    end

    assert Report.exists? reportable: @reportable, body: 'test report',
                          reported_by: @user
  end
end
