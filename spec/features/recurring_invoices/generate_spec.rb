require 'rails_helper'

feature 'Execute Pending Invoices' do

  before do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    recurring_invoice.period = 1
    recurring_invoice.period_type = 'month'
    recurring_invoice.save
    visit 'invoices/'
  end

  scenario 'can generate pending invoices' do
    # There is no Invoice for today
    expect(page).not.to have_content(Date.current.to_s)
    visit 'recurring_invoices/'
    click_link 'Build Pending Invoices'
    # Now there should be 1 Invoice for today
    expect(page).to have_content(Date.current.to_s)
    expect(page).to have_content('New Invoice')

    #invoice = RecurringInvoice.where(name: 'Test Customer').first
    #expect(page.current_url).to eql recurring_invoices_url
  end

  #scenario 'can not create recurring invoice without customer name' do
  #  click_button 'Create Recurring invoice'
  #  expect(page).to have_content("Recurring Invoice has not been created.")
  #  expect(page).to have_content("Customer name can't be blank")
  #end



end
