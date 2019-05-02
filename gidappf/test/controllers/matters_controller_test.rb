require 'test_helper'

class MattersControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @matter = matters(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_matter = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    get matters_url, headers: @auth_h_matter
    assert_response :success
  end

  test "should get new" do
    get new_matter_url, headers: @auth_h_matter
    assert_response :success
  end

  test "should create matter" do
    sign_in users(:one)
    assert_difference('Matter.count') do
      post matters_url, params: { matter: { description: @matter.description, enable: @matter.enable, name: @matter.name, trayect: @matter.trayect } }
    end

    assert_redirected_to matter_url(Matter.last)
    sign_out :one
  end

  test "should show matter" do
    get matter_url(@matter), headers: @auth_h_matter
    assert_response :success
  end

  test "should get edit" do
    get edit_matter_url(@matter), headers: @auth_h_matter
    assert_response :success
  end

  test "should update matter" do
    sign_in users(:one)
    patch matter_url(@matter), params: { matter: { description: @matter.description, enable: @matter.enable, name: @matter.name } }
    assert_redirected_to matter_url(@matter)
    sign_out :one
  end

  test "should destroy matter" do
    sign_in users(:one)
    assert_difference('Matter.count', -1) do
      delete matter_url(@matter), headers: @auth_h_matter
    end

    assert_response :no_content
    sign_out :one
  end
end
