require "rails_helper"

feature "Recurring Invoices:" do
  scenario "User can delete a recurring invoice", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)

    visit edit_recurring_invoice_path(recurring_invoice)
    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eq recurring_invoices_path
    expect(page).not_to have_content "A-1"
  end

  scenario "User can cancel deletion of a recurring invoice", :js => true, :driver => :webkit do
    recurring_invoice = FactoryBot.create(:recurring_invoice)

    visit edit_recurring_invoice_path(recurring_invoice)
    dismiss_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eq edit_recurring_invoice_path(recurring_invoice)
  end
end
