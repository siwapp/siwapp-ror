require 'rails_helper'

feature 'Deleting Customers' do
  scenario 'delete a Customer', :js => true, driver: :webkit do
    FactoryGirl.create(:customer, name: "Test Customer")
    visit "/customers"
	page.find('td', :text => "Test Customer").click

    click_link 'Delete'
    expect(page).to have_content('Customer was successfully destroyed')
    expect(page).to have_no_content('Test Customer')
  end
end
