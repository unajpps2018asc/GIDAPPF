require 'test_helper'

class SetsusersaccessControllerTest < ActionDispatch::IntegrationTest
  test "should get settings" do
    get setsusersaccess_settings_url
    assert_response :success
  end

  test "should get edit" do
    get setsusersaccess_edit_url
    assert_response :success
  end

end
