require 'test_helper'

class GidappfCatchsExceptionsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  test "should get disabled_cookies_detect" do
    sign_in users(:user_test_full_access)
    get gidappf_catchs_exceptions_disabled_cookies_detect_url
    assert_response :success
    sign_out :user
  end

  test "should get first_password_undetect" do
    sign_in users(:user_test_full_access)
    get gidappf_catchs_exceptions_first_password_detect_url
    assert_response :found #no detecta first_password porque es user_test_full_access
    sign_out :user
  end

  test "should get first_password_detect" do
    sign_in users(:anyuser)
    get gidappf_catchs_exceptions_first_password_detect_url
    assert_response :success
    sign_out :user
  end
end
