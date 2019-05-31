require "rails_helper"

feature "Recurring Invoices:" do
  scenario "User can generate pending invoices on demand", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)

    visit recurring_invoices_path
    click_link "Build Pending Invoices"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content "A-1"
    expect(page).to have_content Date.current.to_s
  end
end
