require "application_system_test_case"

class ClassRoomInstitutesTest < ApplicationSystemTestCase
  setup do
    @class_room_institute = class_room_institutes(:one)
  end

  test "visiting the index" do
    visit class_room_institutes_url
    assert_selector "h1", text: "Class Room Institutes"
  end

  test "creating a Class room institute" do
    visit class_room_institutes_url
    click_on "New Class Room Institute"

    fill_in "Available Friday", with: @class_room_institute.available_friday
    fill_in "Available From", with: @class_room_institute.available_from
    fill_in "Available Monday", with: @class_room_institute.available_monday
    fill_in "Available Saturday", with: @class_room_institute.available_saturday
    fill_in "Available Sunday", with: @class_room_institute.available_sunday
    fill_in "Available Thursday", with: @class_room_institute.available_thursday
    fill_in "Available Time", with: @class_room_institute.available_time
    fill_in "Available To", with: @class_room_institute.available_to
    fill_in "Available Tuesday", with: @class_room_institute.available_tuesday
    fill_in "Available Wednesday", with: @class_room_institute.available_wednesday
    fill_in "Capacity", with: @class_room_institute.capacity
    fill_in "Description", with: @class_room_institute.description
    fill_in "Enabled", with: @class_room_institute.enabled
    fill_in "Name", with: @class_room_institute.name
    fill_in "Ubication", with: @class_room_institute.ubication
    click_on "Create Class room institute"

    assert_text "Class room institute was successfully created"
    click_on "Back"
  end

  test "updating a Class room institute" do
    visit class_room_institutes_url
    click_on "Edit", match: :first

    fill_in "Available Friday", with: @class_room_institute.available_friday
    fill_in "Available From", with: @class_room_institute.available_from
    fill_in "Available Monday", with: @class_room_institute.available_monday
    fill_in "Available Saturday", with: @class_room_institute.available_saturday
    fill_in "Available Sunday", with: @class_room_institute.available_sunday
    fill_in "Available Thursday", with: @class_room_institute.available_thursday
    fill_in "Available Time", with: @class_room_institute.available_time
    fill_in "Available To", with: @class_room_institute.available_to
    fill_in "Available Tuesday", with: @class_room_institute.available_tuesday
    fill_in "Available Wednesday", with: @class_room_institute.available_wednesday
    fill_in "Capacity", with: @class_room_institute.capacity
    fill_in "Description", with: @class_room_institute.description
    fill_in "Enabled", with: @class_room_institute.enabled
    fill_in "Name", with: @class_room_institute.name
    fill_in "Ubication", with: @class_room_institute.ubication
    click_on "Update Class room institute"

    assert_text "Class room institute was successfully updated"
    click_on "Back"
  end

  test "destroying a Class room institute" do
    visit class_room_institutes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Class room institute was successfully destroyed"
  end
end
