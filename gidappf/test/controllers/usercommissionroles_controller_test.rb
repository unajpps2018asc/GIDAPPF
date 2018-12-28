require 'test_helper'

class UsercommissionrolesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @usercommissionrole = usercommissionroles(:two)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_ucr = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get edit" do
    # sign_in users(:one)
    get edit_usercommissionrole_path(id: @usercommissionrole.id, radio_selected: roles(:one).id),headers:@auth_h_ucr
    assert_redirected_to  setsusersaccess_settings_path, headers: @auth_h_ucr
    # sign_out :one
  end
end
