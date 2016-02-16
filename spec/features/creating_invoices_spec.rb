require 'rails_helper'

feature 'Creating Invoices' do

  before do
    FactoryGirl.create(:series)
  end

  # For some weird reason this test fails with :webkit but not with :selenium
  #scenario 'can create an invoice', :js => true, driver: :webkit do
  #  visit '/invoices'
  #  first(:link, 'New Invoice').click
  #  select 'Example Series', from: 'invoice_series_id'

  #  fill_in 'Name', with: 'Test Customer'
  #  fill_in 'Email', with: 'pepe@abc.com'
  #  fill_in 'Issue date', with: Date.today

  #  click_on 'Save'
  #  expect(page).to have_content('Invoice was successfully created.')
  #  invoice = Invoice.where(name: 'Test Customer').first
  #  expect(page.current_path).to eql invoices_path

  #  # Chech that customer is created
  #  customer = Customer.where(name: 'Test Customer').first
  #  expect(customer.email).to eq('pepe@abc.com')
  #end

  scenario 'autocomplete of customer fields', :js => true, driver: :webkit do
    FactoryGirl.create_list(:customer, 5)
    visit '/invoices/new'
    fill_in 'Name', with: 'dem'
    # click over the ajax result
    find('li.ui-menu-item').click
    # and we should have data filled
    expect(find('#invoice_email').value).to eq 'info@democompany.com'
    expect(find('#invoice_identification').value).to eq 'D-1234'
  end
end
