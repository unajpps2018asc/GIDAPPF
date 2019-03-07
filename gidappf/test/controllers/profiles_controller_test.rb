require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @profile = profiles(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_profile = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    get profiles_url, headers: @auth_h_profile
    assert_response :success
  end

  test "should get new" do
    get new_profile_url, headers: @auth_h_profile
    assert_response :success
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

    assert_redirected_to profile_url(Profile.last), headers: @auth_h_profile
    sign_out :one
  end

  test "should show profile" do
    get profile_url(@profile), headers: @auth_h_profile
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile), headers: @auth_h_profile
    assert_response :success
  end

  test "should update profile" do
    sign_in users(:one)
    patch profile_url(@profile), params: { profile: { description: @profile.description, name: @profile.name, valid_from: @profile.valid_from, valid_to: @profile.valid_to } }
    assert_redirected_to profile_url(@profile), headers: @auth_h_profile
    sign_out :one
  end

  test "should destroy profile" do
    sign_in users(:one)
    assert_difference('Profile.count', -1) do
      @profile.profile_key.all.each do |e|
        e.profile_value.destroy
      end
      delete profile_url(@profile), headers: @auth_h_profile
    end

    assert_response :no_content
    sign_out :one
  end
end
