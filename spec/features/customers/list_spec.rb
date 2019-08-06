require "rails_helper"

feature "Customers:" do
  scenario "User can see a list of customers", :js => true, :driver => :webkit do
    FactoryBot.create(:customer)
    FactoryBot.create_list(:ncustomer, 2)

    first(:link, :text => 'Customers').click

    expect(page.current_path).to eql customers_path
    expect(page).to have_content "Test Customer"
  end

  scenario "User can click on a customer to edit it", :js => true, :driver => :webkit do
    customer = FactoryBot.create(:customer)

    visit customers_path
    click_link "Test Customer"

    expect(page.current_path).to eql edit_customer_path(customer)
  end

  scenario "User can access to the list of invoices for a certain customer", :js => true, :driver => :webkit do
    customer = FactoryBot.create(:customer)
    invoice = FactoryBot.create(:invoice, customer: customer)

    visit customers_path
    click_link "See Invoices"

    expect(page.current_path).to eql customer_invoices_path(customer)
    expect(page).to have_content invoice.to_s
  end
end
