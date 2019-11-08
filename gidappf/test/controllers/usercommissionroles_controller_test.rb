require 'test_helper'

class UsercommissionrolesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @usercommissionrole = usercommissionroles(:two)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_ucr = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    get edit_usercommissionrole_path(id: @usercommissionrole.id, radio_selected: roles(:anyrole).id)#,headers:@auth_h_ucr
    assert_redirected_to  setsusersaccess_settings_path#, headers: @auth_h_ucr
    sign_out :user
  end
end
