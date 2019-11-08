require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  test "should get current" do
    sign_in users(:user_test_full_access)
    get members_current_url tsh_id: time_sheet_hours(:one).id
    assert_response :success
    sign_out :user
  end

end
