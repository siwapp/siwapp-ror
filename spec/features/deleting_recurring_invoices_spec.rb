require 'spec_helper'

feature "Deleting Recurring Invoices" do
  scenario "Deleting a recurring invoice" do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    visit '/recurring_invoices'
    click_link 'Destroy'
    expect(page).to have_content("Recurring Invoice has been destroyed.")
    visit "/recurring_invoices"
    expect(page).to have_no_content("XXX-1")
  end
end
