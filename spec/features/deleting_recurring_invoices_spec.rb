require 'rails_helper'

feature "Deleting Recurring Invoices" do
  scenario "Deleting a recurring invoice" do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    visit "/recurring_invoices/#{recurring_invoice.id}/edit"
    click_link 'Delete'
    expect(page).to have_content("Recurring Invoice was successfully destroyed.")
    expect(page).to have_no_content("XXX-1")
  end
end
