require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @profile = profiles(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_profile = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    sign_in users(:one)
    get matters_url#, headers: @auth_h_matter
    assert_response :success
    get profiles_path
    assert_redirected_to gidappf_catchs_exceptions_not_record_found_detect_path
    sign_out :user
  end

  test "should create profile" do
    sign_in users(:one)
    assert_difference('Profile.count') do
      post profiles_url, params: { profile: {
        description: "@profile.description",
        name: "@profile.name",
        valid_from: Time.now,
         valid_to: 1.month.after } }
    end

    assert_redirected_to profile_url(Profile.last)#, headers: @auth_h_profile
    sign_out :user
  end

  test "should show profile" do
    sign_in users(:one)
    get profile_url(@profile)#, headers: @auth_h_profile
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_profile_url(@profile)#, headers: @auth_h_profile
    assert_response :success
    sign_out :user
  end

  # Pendiente hacer compatible `template_of_merge' por que los Profile con id 1 y 2 son templates y no figuran en fixtures
  # test "should update profile" do
  #   sign_in users(:one)
  #   @profile = profiles(:two)
  #   patch profile_url(@profile), params: { profile: { description: @profile.description, name: @profile.name, valid_from: @profile.valid_from, valid_to: @profile.valid_to } }
  #   assert_redirected_to profile_url(@profile)
  #   sign_out :user
  # end

  test "should destroy profile" do
    sign_in users(:one)
    assert_difference('Profile.count', -1) do
      @profile.profile_keys.all.each do |e|
        e.profile_values.destroy_all
      end
      delete profile_url(@profile)#, headers: @auth_h_profile
    end

    assert_response :found
    sign_out :user
  end
end
