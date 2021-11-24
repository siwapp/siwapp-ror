require "rails_helper"

feature "Service:" do

  scenario "User can update a service", :js => true, :driver => :webkit do
    vat = FactoryBot.create(:vat)

    visit services_path
    click_on "VAT"

    expect(page.current_path).to eql edit_service_path(vat)

    fill_in "Name", with: "VAT 18%"
    fill_in "Value", with: "18"
    check "Enabled"

    click_on "Save"

    expect(page.current_path).to eql(services_path)
    expect(page).to have_content "successfully updated"
  end

  scenario "User can't update a service with invalid data", :js => true, :driver => :webkit do
    vat = FactoryBot.create(:vat)

    visit edit_service_path(vat)

    fill_in "Value", with: "dieciocho"
    click_on "Save"

    expect(page.current_path).to eql(service_path(vat))
    # Webkit only allows numbers for numeric fields so probably the field
    # couldn't be changed to hold "dieciocho" as its value. In that case
    # we get 2 errors instead of 1.
    expect(page).to have_content "2 errors"
  end

end
