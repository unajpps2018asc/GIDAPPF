require "application_system_test_case"

class TimeSheetHoursTest < ApplicationSystemTestCase
  setup do
    @time_sheet_hour = time_sheet_hours(:one)
  end

  test "visiting the index" do
    visit time_sheet_hours_url
    assert_selector "h1", text: "Time Sheet Hours"
  end

  test "creating a Time sheet hour" do
    visit time_sheet_hours_url
    click_on "New Time Sheet Hour"

    fill_in "Friday", with: @time_sheet_hour.friday
    fill_in "From Hour", with: @time_sheet_hour.from_hour
    fill_in "From Min", with: @time_sheet_hour.from_min
    fill_in "Monday", with: @time_sheet_hour.monday
    fill_in "Saturday", with: @time_sheet_hour.saturday
    fill_in "Sunday", with: @time_sheet_hour.sunday
    fill_in "Thursday", with: @time_sheet_hour.thursday
    fill_in "Time Sheet", with: @time_sheet_hour.time_sheet_id
    fill_in "To Hour", with: @time_sheet_hour.to_hour
    fill_in "To Min", with: @time_sheet_hour.to_min
    fill_in "Tuesday", with: @time_sheet_hour.tuesday
    fill_in "Wednesday", with: @time_sheet_hour.wednesday
    click_on "Create Time sheet hour"

    assert_text "Time sheet hour was successfully created"
    click_on "Back"
  end

  test "updating a Time sheet hour" do
    visit time_sheet_hours_url
    click_on "Edit", match: :first

    fill_in "Friday", with: @time_sheet_hour.friday
    fill_in "From Hour", with: @time_sheet_hour.from_hour
    fill_in "From Min", with: @time_sheet_hour.from_min
    fill_in "Monday", with: @time_sheet_hour.monday
    fill_in "Saturday", with: @time_sheet_hour.saturday
    fill_in "Sunday", with: @time_sheet_hour.sunday
    fill_in "Thursday", with: @time_sheet_hour.thursday
    fill_in "Time Sheet", with: @time_sheet_hour.time_sheet_id
    fill_in "To Hour", with: @time_sheet_hour.to_hour
    fill_in "To Min", with: @time_sheet_hour.to_min
    fill_in "Tuesday", with: @time_sheet_hour.tuesday
    fill_in "Wednesday", with: @time_sheet_hour.wednesday
    click_on "Update Time sheet hour"

    assert_text "Time sheet hour was successfully updated"
    click_on "Back"
  end

  test "destroying a Time sheet hour" do
    visit time_sheet_hours_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Time sheet hour was successfully destroyed"
  end
end
