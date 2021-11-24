require "rails_helper"

feature "Service:" do
  scenario "User can create a service", :js => true, :driver => :webkit do
    visit services_path
    click_on "New Service"

    expect(page.current_path).to eql new_service_path

    fill_in "Name", with: "IVA"
    fill_in "Value", with: "15"
    check "Enabled"
    check "Apply to new items by default"

    click_button "Save"

    expect(page.current_path).to eql services_path
    expect(page).to have_content "successfully created"
  end

  scenario "User can't create a service with invalid data", :js => true, :driver => :webkit do
    visit new_service_path
    click_on "Save"

    expect(page.current_path).to eql services_path
    expect(page).to have_content "3 errors"
  end
end
