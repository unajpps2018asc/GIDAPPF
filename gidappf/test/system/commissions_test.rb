require "application_system_test_case"

class CommissionsTest < ApplicationSystemTestCase
  setup do
    @commission = commissions(:incoming)
  end

  test "visiting the index" do
    visit commissions_url
    assert_selector "h1", text: "Commissions"
  end

  test "creating a Commission" do
    visit commissions_url
    click_on "New Commission"

    fill_in "Description", with: @commission.description
    fill_in "End Date", with: @commission.end_date
    fill_in "Name", with: @commission.name
    fill_in "Start Date", with: @commission.start_date
    click_on "Create Commission"

    assert_text "Commission was successfully created"
    click_on "Back"
  end

  test "updating a Commission" do
    visit commissions_url
    click_on "Edit", match: :first

    fill_in "Description", with: @commission.description
    fill_in "End Date", with: @commission.end_date
    fill_in "Name", with: @commission.name
    fill_in "Start Date", with: @commission.start_date
    click_on "Update Commission"

    assert_text "Commission was successfully updated"
    click_on "Back"
  end

  test "destroying a Commission" do
    visit commissions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Commission was successfully destroyed"
  end
end
