require 'test_helper'

class SetsStudentsControllerTest < ActionDispatch::IntegrationTest
  test "should get change_commission" do
    get sets_students_change_commission_url
    assert_response :found
  end

  test "should get selected_commission" do
    get sets_students_selected_commission_url
    assert_response :found
  end

end
