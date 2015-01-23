require 'rails_helper'

feature "Creating Items" do
  before do
    FactoryGirl.create(:invoice, customer_name:"Test Customer Invoice")
    visit "/invoices"
    click_link "XXX-1"
    click_link "New Item"
  end

  scenario "Creating an Item" do
    fill_in "Description", with: 'A new item for this invoice'
    fill_in 'Quantity', with: 5
    fill_in 'Unitary cost', with: 12.3
    click_button "Create Item"
    expect(page).to have_content("Item was successfully created")
  end

  scenario "Creating an Item with wrong attributes fails" do
    click_button "Create Item"
    expect(page).to have_content("Item has not been created.")
    expect(page).to have_content("Description can't be blank")
  end

end
