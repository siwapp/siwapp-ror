require 'rails_helper'

feature 'Editing Customer' do
  before do
    FactoryGirl.create(:customer, name: "Test Customer")
    visit "/customers"
	page.find('td', :text => "Test Customer").click
  end

  scenario 'updating a Customer', :js => true, driver: :webkit do
    fill_in 'Name', with: 'NEW Test Customer'
    click_on 'Save'
    expect(page).to have_content("Customer was successfully updated")
    expect(page).to have_content("NEW Test Customer")
  end

  scenario 'can not update badly', :js => true, driver: :webkit do
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name or identification is required.")
    expect(page).to have_content('1 error prohibited this customer from being saved:')
  end

end
