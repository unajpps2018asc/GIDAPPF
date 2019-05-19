require 'test_helper'

class InputsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @input = inputs(:one)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_h_in = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    get inputs_url
    assert_response :found
  end

  test "should get new" do
    sign_in users(:one)
    get new_input_url, headers: @auth_h_in
    assert_response :success
  end

  test "should create input" do
    sign_in users(:one)
    assert_difference('Input.count') do
      post inputs_url, params: { input: {
        author: @input.author, enable: @input.enable,
        grouping: @input.grouping, summary: @input.summary,
        title: @input.title } }
    end

    assert_redirected_to input_url(Input.last)
    sign_out :one
  end

  test "should show input" do
    get input_url(@input), headers: @auth_h_in
    assert_response :success
  end

  test "should get edit" do
    get edit_input_url(@input), headers: @auth_h_in
    assert_response :success
  end

  # Pendiente hacer compatible `template_of_merge' por que los Profile con id 1 y 2 son templates y no figuran en fixtures
  # test "should update input" do
  #   sign_in users(:one)
  #   patch input_url(@input), params: { input: { author: @input.author, enable: @input.enable, grouping: @input.grouping, summary: @input.summary, title: @input.title } }
  #   assert_redirected_to input_url(@input)
  #   sign_out :one
  # end

  test "should destroy input" do
    sign_in users(:one)
    assert_difference('Input.count', -1) do
      delete input_url(@input), headers: @auth_h_in
    end

    assert_response :no_content
    sign_out :one
  end
end
