require 'rails_helper'

feature 'Creating Recurring Invoices' do

  before do
    visit '/recurring_invoices'
    click_link 'New Recurring Invoice'
  end

  scenario 'can create a recurring invoice' do
    fill_in 'Customer name', with: 'Test Customer'
    fill_in 'Number', with: '1'
    fill_in 'Customer email', with: 'pepe@abc.com'
    click_button 'Create Recurring invoice'
    expect(page).to have_content('Recurring Invoice was successfully created.')
    invoice = RecurringInvoice.where(customer_name: 'Test Customer').first
    expect(page.current_url).to eql(recurring_invoice_url(invoice))
  
    title = "Siwapp - Recurring Invoices - Test Customer"
    expect(page).to have_title(title)
  end

  #scenario 'can not create recurring invoice without customer name or number' do
  #  click_button 'Create Recurring invoice'
  #  #expect(page).to have_content("Recurring Invoice has not been created.")
  #  expect(page).to have_content("Customer name can't be blank")
  #  expect(page).to have_content("Number can't be blank")
  #end



end
