require "application_system_test_case"

class UsercommissionrolesTest < ApplicationSystemTestCase
  setup do
    @usercommissionrole = usercommissionroles(:one)
  end

  test "visiting the index" do
    visit usercommissionroles_url
    assert_selector "h1", text: "Usercommissionroles"
  end

  test "creating a Usercommissionrole" do
    visit usercommissionroles_url
    click_on "New Usercommissionrole"

    fill_in "Commission", with: @usercommissionrole.commission_id
    fill_in "Role", with: @usercommissionrole.role_id
    fill_in "User", with: @usercommissionrole.user_id
    click_on "Create Usercommissionrole"

    assert_text "Usercommissionrole was successfully created"
    click_on "Back"
  end

  test "updating a Usercommissionrole" do
    visit usercommissionroles_url
    click_on "Edit", match: :first

    fill_in "Commission", with: @usercommissionrole.commission_id
    fill_in "Role", with: @usercommissionrole.role_id
    fill_in "User", with: @usercommissionrole.user_id
    click_on "Update Usercommissionrole"

    assert_text "Usercommissionrole was successfully updated"
    click_on "Back"
  end

  test "destroying a Usercommissionrole" do
    visit usercommissionroles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Usercommissionrole was successfully destroyed"
  end
end
