require 'rails_helper'

feature 'Viewing invoices' do
  scenario 'Listing all invoices' do
    invoice = FactoryGirl.create(:invoice, customer_name: "Test Invoice", number: "1")
    visit "/invoices"
    click_link "XXX-1"
    expect(page.current_url).to eql(invoice_url(invoice))
  end
end
