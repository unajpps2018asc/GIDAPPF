require 'test_helper'

class CampusMagnamentsControllerTest < ActionDispatch::IntegrationTest
  test "should get get_campus_segmentation" do
    get campus_magnaments_get_campus_segmentation_url
    assert_response :found
  end

  test "should get set_campus_segmentation" do
    get campus_magnaments_set_campus_segmentation_url
    assert_response :found
  end

end
