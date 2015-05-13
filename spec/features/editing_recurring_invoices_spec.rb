require 'spec_helper'

feature "Editing Recurring Invoices" do
  before  do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)
    visit "/recurring_invoices/#{recurring_invoice.id}/edit"
  end

  scenario "Updating a recurring invoice" do
    expect(page).to have_content("Edit Recurring Invoice")
    fill_in "Customer name", with: "TextMate 2 beta"
    click_button "Update Recurring invoice"

    expect(page).to have_content("Recurring Invoice was successfully updated.")
  end

  scenario "Updating a recurring invoice with invalid attributes is bad" do
    fill_in "Customer name", with: ""
    fill_in "Starting date", with: Date.today
    fill_in "Finishing date", with: Date.yesterday
    click_button "Update Recurring invoice"
    expect(page).to have_content("Customer name can't be blank")
    expect(page).to have_content("Finishing Date must be after Starting Date")
  end

end
