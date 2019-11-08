require 'test_helper'

class InputsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @input = inputs(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_in = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get index" do
    sign_in users(:user_test_full_access)
    get inputs_url
    assert_response :success
    sign_out :user
  end

  test "should get new" do
    sign_in users(:user_test_full_access)
    get new_input_url#, headers: @auth_h_in
    assert_response :found
    sign_out :user
  end

  test "should create input" do
    sign_in users(:user_test_full_access)
    assert_difference('Input.count') do
      post inputs_url, params: { input: {
        author: @input.author, enable: @input.enable,
        grouping: @input.grouping, summary: @input.summary,
        title: @input.title } }
    end

    assert_redirected_to input_url(Input.last)
    sign_out :user
  end

  test "should show input" do
    sign_in users(:user_test_full_access)
    get input_url(@input)#, headers: @auth_h_in
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    get edit_input_url(@input)#, headers: @auth_h_in
    assert_response :success
    sign_out :user
  end

  # Pendiente hacer compatible `template_of_merge' por que los Profile con id 1 y 2 son templates y no figuran en fixtures
  # test "should update input" do
  #   sign_in users(:user_test_full_access)
  #   patch input_url(@input), params: { input: { author: @input.author, enable: @input.enable, grouping: @input.grouping, summary: @input.summary, title: @input.title } }
  #   assert_redirected_to input_url(@input)
  #   sign_out :user
  # end

  test "should destroy input" do
    sign_in users(:user_test_full_access)
    assert_difference('Input.count', -1) do
      delete input_url(@input)#, headers: @auth_h_in
    end

    assert_response :found
    sign_out :user
  end
end
