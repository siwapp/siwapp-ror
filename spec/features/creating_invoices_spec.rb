require 'rails_helper'

feature 'Creating Invoices' do

  before do
    FactoryGirl.create(:series)

  end

  scenario 'can create an invoice' do
    visit '/signup'
    fill_in 'Name', with: 'Test Customer'
    fill_in 'Email', with: 'test@llll.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Confirmation', with: '12345678'
    click_button('Create my account')
    visit '/invoices'
    first(:link, 'New Invoice').click
    select 'Example Series', from: 'invoice_series_id'

    fill_in 'Name', with: 'Test Customer'
    fill_in 'Email', with: 'pepe@abc.com'
    fill_in 'Issue date', with: Date.today

    click_button 'Create Invoice'
    expect(page).to have_content('Invoice was successfully created.')
    invoice = Invoice.where(name: 'Test Customer').first
    expect(page.current_url).to eql invoices_url

  end
end
