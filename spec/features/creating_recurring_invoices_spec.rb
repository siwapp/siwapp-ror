require 'rails_helper'

feature 'Creating Recurring Invoices' do

  before do
    FactoryGirl.create(:series)
    visit '/recurring_invoices'
    click_link 'New Recurring Invoice'
  end

  scenario 'can create a recurring invoice' do
    select 'Example Series', from: 'recurring_invoice_series_id'

    fill_in 'Starting date', with: '2015-02-28'
    fill_in 'Finishing date', with: '2015-03-01'

    fill_in 'Name', with: 'Test Customer'
    fill_in 'Email', with: 'pepe@abc.com'

    click_button 'Create Recurring invoice'
    expect(page).to have_content('Recurring Invoice was successfully created.')

    invoice = RecurringInvoice.where(name: 'Test Customer').first
    expect(page.current_url).to eql recurring_invoices_url
  end

  scenario 'can not create recurring invoice without customer name' do
    click_button 'Create Recurring invoice'
    expect(page).to have_content("Recurring Invoice has not been created.")
    expect(page).to have_content("Name can't be blank")
  end



end
