require 'rails_helper'

feature 'Creating Invoices' do

  before do
    FactoryGirl.create(:serie)
    visit '/invoices'
    first(:link, 'New Invoice').click
  end

  scenario 'can create an invoice' do
    select 'Example Series', from: 'invoice_serie_id'

    fill_in 'Customer name', with: 'Test Customer'
    fill_in 'Customer email', with: 'pepe@abc.com'
    fill_in 'Issue date', with: Date.today

    click_button 'Create Invoice'
    expect(page).to have_content('Invoice was successfully created.')
    invoice = Invoice.where(customer_name: 'Test Customer').first
    expect(page.current_url).to eql invoices_url

  end
end
