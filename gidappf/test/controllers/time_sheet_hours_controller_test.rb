require 'test_helper'

class TimeSheetHoursControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @time_sheet_hour = time_sheet_hours(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_tsh = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get index" do
    sign_in users(:user_test_full_access)
    get time_sheet_hours_url#, headers: @auth_h_tsh
    assert_response :success
    sign_out :user
  end

  # test "should get new" do
  #   sign_in users(:user_test_full_access)
  #   get new_time_sheet_hour_url, headers: @auth_h_tsh
  #   assert_response :success
  #   sign_out :user
  # end

  test "should create time_sheet_hour" do
    sign_in users(:user_test_full_access)
    assert_difference('TimeSheetHour.count') do
      post time_sheet_hours_url, params: {
        time_sheet_hour: {
          time_sheet_id: @time_sheet_hour.time_sheet_id,
          matter_id: @time_sheet_hour.matter_id,
          vacancy_id: @time_sheet_hour.vacancy_id,
          from_hour: @time_sheet_hour.from_hour,
          to_hour: @time_sheet_hour.to_hour,
          from_min: @time_sheet_hour.from_min,
          to_min: @time_sheet_hour.to_min,
          monday: @time_sheet_hour.monday,
          sunday: @time_sheet_hour.sunday,
          thursday: @time_sheet_hour.thursday,
          friday: @time_sheet_hour.friday,
          saturday: @time_sheet_hour.saturday,
          tuesday: @time_sheet_hour.tuesday,
          wednesday: @time_sheet_hour.wednesday
          } }
    end
    assert_redirected_to time_sheet_hour_url(TimeSheetHour.last)#, headers: @auth_h_tsh
    sign_out :user
  end

  test "should show time_sheet_hour" do
    sign_in users(:user_test_full_access)
    get time_sheet_hour_url(@time_sheet_hour)#, headers: @auth_h_tsh
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    get edit_time_sheet_hour_url(@time_sheet_hour)#, headers: @auth_h_tsh
    assert_response :success
    sign_out :user
  end

  test "should update time_sheet_hour" do
    sign_in users(:user_test_full_access)
    patch time_sheet_hour_url(@time_sheet_hour),
    params: {
      time_sheet_hour: {
        friday: @time_sheet_hour.friday,
        from_hour: @time_sheet_hour.from_hour,
        from_min: @time_sheet_hour.from_min,
        monday: @time_sheet_hour.monday,
        saturday: @time_sheet_hour.saturday,
        sunday: @time_sheet_hour.sunday,
        thursday: @time_sheet_hour.thursday,
        time_sheet_id: @time_sheet_hour.time_sheet_id,
        to_hour: @time_sheet_hour.to_hour,
        to_min: @time_sheet_hour.to_min,
        tuesday: @time_sheet_hour.tuesday,
        wednesday: @time_sheet_hour.wednesday
        } }
    assert_redirected_to time_sheet_hour_url(@time_sheet_hour)
    sign_out :user
  end

  test "should destroy time_sheet_hour" do
    sign_in users(:user_test_full_access)
    assert_difference('TimeSheetHour.count', -1) do
      delete time_sheet_hour_url(@time_sheet_hour)#, headers: @auth_h_tsh
    end

    assert_response :found
    sign_out :user
  end

  # Pendiente la compatibilidad con post_multiple
  # test "should get multiple_new" do
  #   get time_sheet_hours_multiple_new_url#, headers: @auth_h_tsh
  #   assert_redirected_to :root
  # end

end
