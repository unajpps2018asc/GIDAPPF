require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
  test "should get team" do
    get about_team_url
    assert_response :success
  end

end
