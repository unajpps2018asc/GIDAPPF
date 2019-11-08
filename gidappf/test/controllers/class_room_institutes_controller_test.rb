require 'test_helper'

class ClassRoomInstitutesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @class_room_institute = class_room_institutes(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_cri = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get index" do
    sign_in users(:user_test_full_access)
    get class_room_institutes_url#, headers: @auth_h_cri
    assert_response :success
    sign_out :user
  end

  test "should get new" do
    sign_in users(:user_test_full_access)
    get class_room_institutes_url#, headers: @auth_h_cri
    assert_response :success
    sign_out :user
  end

  test "should create class_room_institute" do
    sign_in users(:user_test_full_access)
    assert_difference('ClassRoomInstitute.count') do
      post class_room_institutes_url, params: { class_room_institute: { available_friday: @class_room_institute.available_friday, available_from: @class_room_institute.available_from, available_monday: @class_room_institute.available_monday, available_saturday: @class_room_institute.available_saturday, available_sunday: @class_room_institute.available_sunday, available_thursday: @class_room_institute.available_thursday, available_time: @class_room_institute.available_time, available_to: @class_room_institute.available_to, available_tuesday: @class_room_institute.available_tuesday, available_wednesday: @class_room_institute.available_wednesday, capacity: @class_room_institute.capacity, description: @class_room_institute.description, enabled: @class_room_institute.enabled, name: @class_room_institute.name, ubication: @class_room_institute.ubication } }
    end

    assert_redirected_to class_room_institute_url(ClassRoomInstitute.last)
    sign_out :user
  end

  test "should show class_room_institute" do
    sign_in users(:user_test_full_access)
    get class_room_institute_url(@class_room_institute)#, headers: @auth_h_cri
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    @class_room_institute.enabled=true
    get class_room_institute_url(@class_room_institute)#, headers: @auth_h_cri
    assert_response :success
    get "/class_room_institutes#edit" #, headers: @auth_h_cri
    assert_response :success
    sign_out :user
  end

  test "should update class_room_institute" do
    sign_in users(:user_test_full_access)
    patch class_room_institute_url(@class_room_institute), params: { class_room_institute: { available_friday: @class_room_institute.available_friday, available_from: @class_room_institute.available_from, available_monday: @class_room_institute.available_monday, available_saturday: @class_room_institute.available_saturday, available_sunday: @class_room_institute.available_sunday, available_thursday: @class_room_institute.available_thursday, available_time: @class_room_institute.available_time, available_to: @class_room_institute.available_to, available_tuesday: @class_room_institute.available_tuesday, available_wednesday: @class_room_institute.available_wednesday, capacity: @class_room_institute.capacity, description: @class_room_institute.description, enabled: @class_room_institute.enabled, name: @class_room_institute.name, ubication: @class_room_institute.ubication } }
    assert_redirected_to class_room_institute_url(@class_room_institute)
    sign_out :user
  end

  test "should destroy class_room_institute" do
    sign_in users(:user_test_full_access)
    assert_difference('ClassRoomInstitute.count', -1) do
      delete class_room_institute_url(@class_room_institute)#, headers: @auth_h_cri
    end
    assert_response :found
    sign_out :user
  end
end
