require 'rails_helper'

feature 'Execute Pending Invoices' do

  before do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    recurring_invoice.period = 1
    recurring_invoice.period_type = 'months'
    recurring_invoice.save
    visit 'recurring_invoices/'
  end

  scenario 'can generate pending invoices' do
    click_link 'Build Pending Invoices'
    expect(page).to have_content(Date.today.to_s)
    expect(page).to have_content('New Invoice')

    #invoice = RecurringInvoice.where(customer_name: 'Test Customer').first
    #expect(page.current_url).to eql recurring_invoices_url
  end

  #scenario 'can not create recurring invoice without customer name' do
  #  click_button 'Create Recurring invoice'
  #  expect(page).to have_content("Recurring Invoice has not been created.")
  #  expect(page).to have_content("Customer name can't be blank")
  #end



end
