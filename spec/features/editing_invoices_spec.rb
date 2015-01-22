require 'rails_helper'

feature 'Editing Invoices' do
  before do
    FactoryGirl.create(:invoice, customer_name:"Test Customer Name")
    visit "/invoices"
    click_link "XXX-1"
    click_link "Edit"
  end

  scenario 'Updating an Invoice' do
    fill_in 'Customer name', with: 'NEW Test Customer Name'
    fill_in 'Number', with: '3'
    click_button 'Update Invoice'
    expect(page).to have_content("Invoice was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Customer name', with: ''
    fill_in 'Number', with: ''
    click_button 'Update Invoice'
    expect(page).to have_content('Invoice has not been saved')
    expect(page).to have_content("Customer name can't be blank")
    expect(page).to have_content("Number can't be blank")
  end
end

