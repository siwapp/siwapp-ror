require "rails_helper"

feature "Invoices:" do
  scenario "User can delete an invoice", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)
    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eq invoices_path
    expect(page).not_to have_content "A-1"
  end

  scenario "User can cancel deletion of an invoice", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)
    dismiss_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eq edit_invoice_path(invoice)
  end
end
