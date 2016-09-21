require 'rails_helper'

feature 'Listing Customer' do
  scenario 'show list of customer', :js => true, driver: :webkit do
    FactoryGirl.create(:customer, name: "Test Customer 1")
    FactoryGirl.create(:customer, name: "Test Customer 2")
    FactoryGirl.create(:customer, name: "Test Customer 3")

    visit "/customers"

    expect(page).to have_content("Test Customer 1")
    expect(page).to have_content("Test Customer 2")
    expect(page).to have_content("Test Customer 3")
  end
end
