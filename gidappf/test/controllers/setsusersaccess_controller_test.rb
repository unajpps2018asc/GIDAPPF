require 'test_helper'

class SetsusersaccessControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @usercommissionrole = usercommissionroles(:one)
    @role = roles(:anyrole)
    @commission = commissions(:incoming)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_sets = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get settings" do
    sign_in users(:user_test_full_access)
    get setsusersaccess_settings_url#, headers: @auth_h_sets
    assert_response :success
    sign_out :user
  end
end
