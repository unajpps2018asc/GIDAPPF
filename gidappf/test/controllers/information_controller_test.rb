require 'test_helper'

class InformationControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @information = information(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_info = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    get information_index_url
    assert_response :found
  end

  test "should get new" do
    get new_information_url, headers: @auth_h_info
    assert_response :success
  end

  test "should create information" do
    sign_in users(:one)
    assert_difference('Information.count') do
      post information_index_url, params: { information: {
        author: "@information.author",
        enable: true,
        grouping: true,
        summary: "@information.summary",
        title: "@information.title" } }
    end

    assert_redirected_to information_url(Information.last), headers: @auth_h_info
    sign_out :one
  end

  test "should show information" do
    get information_url(@information), headers: @auth_h_info
    assert_response :success
  end

  test "should get edit" do
    get edit_information_url(@information), headers: @auth_h_info
    assert_response :success
  end

  test "should update information" do
    sign_in users(:one)
    patch information_url(@information), params: { information: { author: @information.author, enable: @information.enable, grouping: @information.grouping, summary: @information.summary, title: @information.title } }
    assert_redirected_to information_url(@information)
    sign_out :one
  end

  test "should destroy information" do
    sign_in users(:one)
    assert_difference('Information.count', -1) do
      delete information_url(@information), headers: @auth_h_info
    end

    assert_response :no_content
    sign_out :one
  end
end
