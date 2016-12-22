require "rails_helper"

feature "Customers:" do
  scenario "User can delete a customer", :js => true, :driver => :webkit do
    FactoryGirl.create(:customer)

    visit "/customers/1/edit"

    expect(page).to have_content("Test Customer")

    click_link "Delete"

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully destroyed.")
    expect(page).to have_no_content("Test Customer")
  end
end
