require "rails_helper"

feature "Customers:" do
  scenario "User can delete a customer", :js => true, :driver => :webkit do
    customer = FactoryBot.create(:customer)

    visit edit_customer_path(customer)

    expect(page).to have_content("Test Customer")

    accept_confirm do
      click_link "Delete"
    end

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully destroyed.")
    expect(page).not_to have_content("Test Customer")
  end

  scenario "User can delete a customer without pending invoices", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice, :paid)

    visit edit_customer_path(invoice.customer)

    accept_confirm do
      click_link "Delete"
    end

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully destroyed.")
    expect(page).not_to have_content("Test Customer")
  end

  scenario "User can't delete a customer with pending invoices", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)

    visit edit_customer_path(invoice.customer)

    accept_confirm do
      click_link "Delete"
    end

    expect(page.current_path).to eql customer_path(invoice.customer)
    expect(page).to have_content "1 error"
    expect(page).to have_content "unpaid invoices"
  end
end
