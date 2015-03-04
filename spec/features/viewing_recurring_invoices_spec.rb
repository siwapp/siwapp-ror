require 'rails_helper'

feature "Viewing recurring invoices" do

  scenario "Listing all recurring invoices" do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    visit '/recurring_invoices'
    click_link 'Example Customer Name'
    expect(page.current_url).to eql(recurring_invoice_url(recurring_invoice))
  end
end
