require "rails_helper"

feature "Customers:" do
  scenario "User can updating a customer", :js => true, :driver => :webkit do
    FactoryGirl.create(:customer)

    visit "/customers/1/edit"

    fill_in "Name", with: "Test Customer Fernandez"

    click_on "Save"

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully updated")
    expect(page).to have_content("Test Customer Fernandez")
  end

  scenario "User can't update a customer with invalid data", :js => true, :driver => :webkit do
    customer = FactoryGirl.create(:customer)

    visit "/customers/1/edit"

    fill_in "Name", with: ""
    fill_in "VAT ID", with: ""

    click_on "Save"

    expect(page.current_path).to eql(customer_path(customer))
    expect(page).to have_content("1 error prohibited this customer from being saved:")
    expect(page).to have_content("Name or identification is required.")
  end
end
