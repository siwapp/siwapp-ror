require 'rails_helper'

feature 'Creating Invoices' do

  before do
    visit '/invoices'
    click_link 'New Invoice'
  end

  scenario 'can create an invoice' do
    fill_in 'Customer name', with: 'Test Customer'
    fill_in 'Number', with: '1'
    click_button 'Create Invoice'
    expect(page).to have_content('Invoice was successfully created.')
    invoice = Invoice.where(customer_name: 'Test Customer').first
    expect(page.current_url).to eql(invoice_url(invoice))
  
    title = "Siwapp - Invoices - Test Customer"
    expect(page).to have_title(title)
  end

  scenario 'can not create invoice without customer name or number' do
    click_button 'Create Invoice'
    expect(page).to have_content("Invoice has not been created.")
    expect(page).to have_content("Customer name can't be blank")
    expect(page).to have_content("Number can't be blank")
  end



end
