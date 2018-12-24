require 'test_helper'

class UsercommissionrolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usercommissionrole = usercommissionroles(:one)
  end

  test "should get index" do
    get usercommissionroles_url
    assert_response :success
  end

  test "should get new" do
    get new_usercommissionrole_url
    assert_response :success
  end

  test "should create usercommissionrole" do
    assert_difference('Usercommissionrole.count') do
      post usercommissionroles_url, params: { usercommissionrole: { commission_id: @usercommissionrole.commission_id, role_id: @usercommissionrole.role_id, user_id: @usercommissionrole.user_id } }
    end

    assert_redirected_to usercommissionrole_url(Usercommissionrole.last)
  end

  test "should show usercommissionrole" do
    get usercommissionrole_url(@usercommissionrole)
    assert_response :success
  end

  test "should get edit" do
    get edit_usercommissionrole_url(@usercommissionrole)
    assert_response :success
  end

  test "should update usercommissionrole" do
    patch usercommissionrole_url(@usercommissionrole), params: { usercommissionrole: { commission_id: @usercommissionrole.commission_id, role_id: @usercommissionrole.role_id, user_id: @usercommissionrole.user_id } }
    assert_redirected_to usercommissionrole_url(@usercommissionrole)
  end

  test "should destroy usercommissionrole" do
    assert_difference('Usercommissionrole.count', -1) do
      delete usercommissionrole_url(@usercommissionrole)
    end

    assert_redirected_to usercommissionroles_url
  end
end
