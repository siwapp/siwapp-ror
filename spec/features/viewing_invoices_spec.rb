require 'rails_helper'

feature 'Viewing invoices' do
  scenario 'Listing all invoices' do
    invoice = FactoryGirl.create(:invoice)
    visit "/invoices"
    click_link "ES-1"
    expect(page.current_url).to eql(invoice_url(invoice))
  end
end
