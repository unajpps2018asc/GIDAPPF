require "application_system_test_case"

class MattersTest < ApplicationSystemTestCase
  setup do
    @matter = matters(:one)
  end

  test "visiting the index" do
    visit matters_url
    assert_selector "h1", text: "Matters"
  end

  test "creating a Matter" do
    visit matters_url
    click_on "New Matter"

    fill_in "Description", with: @matter.description
    check "Enable" if @matter.enable
    fill_in "Name", with: @matter.name
    click_on "Create Matter"

    assert_text "Matter was successfully created"
    click_on "Back"
  end

  test "updating a Matter" do
    visit matters_url
    click_on "Edit", match: :first

    fill_in "Description", with: @matter.description
    check "Enable" if @matter.enable
    fill_in "Name", with: @matter.name
    click_on "Update Matter"

    assert_text "Matter was successfully updated"
    click_on "Back"
  end

  test "destroying a Matter" do
    visit matters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Matter was successfully destroyed"
  end
end
