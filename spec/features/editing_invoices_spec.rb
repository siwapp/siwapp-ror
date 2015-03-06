require 'rails_helper'

feature 'Editing Invoices' do
  before do
    FactoryGirl.create(:invoice)
    visit "/invoices"
    click_link "ES-1"
    click_link "Edit"
  end

  scenario 'Updating an Invoice' do
    fill_in 'Customer name', with: 'Different Name'
    fill_in 'Customer email', with: 'different.name@test.com'
    fill_in 'Due date', with: Date.today + 30
    click_button 'Update Invoice'
    expect(page).to have_content("Invoice was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Customer name', with: ''
    fill_in 'Customer email', with: 'pepe.com'
    click_button 'Update Invoice'
    expect(page).to have_content('Invoice has not been saved')
    expect(page).to have_content("Only valid emails")
  end
end

