require 'test_helper'

class TimeSheetsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_ts = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get associate" do
    get time_sheets_associate_url, headers: @auth_h_ts
    assert_response :success
  end

end
