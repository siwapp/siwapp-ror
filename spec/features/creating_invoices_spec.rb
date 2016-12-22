require 'rails_helper'

feature 'Creating Invoices' do

  before do
    FactoryGirl.create(:series, :default)
  end

  scenario 'can create an invoice', :js => true, driver: :webkit do
    visit '/invoices'
    first(:link, 'New Invoice').click
    expect(page).to have_css('div.row textarea') # empty item
    select 'A- Series', from: 'invoice_series_id'

    fill_in 'Name', with: 'Test Customer'
    fill_in 'Email', with: 'pepe@abc.com'
    fill_in 'Issue date', with: Date.current

    click_on 'Save'

    expect(page).to have_content('Invoice was successfully created.')
    expect(page.current_path).to eql invoices_path

    # Chech that customer is created
    customer = Customer.find_by(name: 'Test Customer')
    expect(customer).not_to be nil
    expect(customer.email).to eq('pepe@abc.com')
  end

  scenario 'autocomplete of customer fields', :js => true, driver: :webkit do
    FactoryGirl.create_list(:ncustomer, 5)

    visit '/invoices/new'

    fill_in 'Name', with: 'hou'
    find('.ui-menu-item', :text => 'Warehousing').click

    # and we should have data filled
    expect(find_field('invoice_name').value).to eq 'Warehousing'
    expect(find_field('invoice_email').value).to eq 'info@warehousing.com'
  end
end
