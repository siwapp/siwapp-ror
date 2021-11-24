require "rails_helper"

feature "Services:" do
  scenario "User can mark a service as default from the list of services", :js => true, :driver => :webkit do
    FactoryBot.create(:vat, default: true)
    FactoryBot.create(:retention)

    click_on "Account"
    click_on "Services"

    expect(page.current_path).to eql services_path

    expect(page).to have_content "VAT"
    expect(page).to have_content "RETENTION"
    expect(page).to have_checked_field "default_service_1"   # VAT
    expect(page).to have_unchecked_field "default_service_2" # RETENTION

    find_field("default_service_2").click

    expect(page.current_path).to eql services_path
    expect(page).to have_checked_field "default_service_1" # VAT
    expect(page).to have_checked_field "default_service_2" # RETENTION
  end
end
