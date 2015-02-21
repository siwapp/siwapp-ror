require 'rails_helper'

feature 'Editing Invoices' do
  before do
    FactoryGirl.create(:invoice, customer_name:"Test Customer Name")
    visit "/invoices"
    click_link "ES-1"
    click_link "Edit"
  end

  scenario 'Updating an Invoice' do
    fill_in 'Customer name', with: 'NEW Test Customer Name'
    fill_in 'Number', with: '3'
    fill_in 'Customer email', with: 'test@test.com'
    fill_in 'Due date', with: '2015/03/03'
    click_button 'Update Invoice'
    expect(page).to have_content("Invoice was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Customer name', with: ''
    fill_in 'Number', with: 'x'
    fill_in 'Customer email', with: 'pepe.com'
    click_button 'Update Invoice'
    expect(page).to have_content('Invoice has not been saved')
    expect(page).to have_content("Number is not a number")
    expect(page).to have_content("Only valid emails")
  end
end

