require "rails_helper"

feature "Taxes:" do
  scenario "User can create a tax", :js => true, :driver => :webkit do
    visit taxes_path
    click_on "New Tax"

    expect(page.current_path).to eql new_tax_path

    fill_in "Name", with: "IVA"
    fill_in "Value", with: "15"
    check "Enabled"
    check "Apply to new items by default"

    click_button "Save"

    expect(page.current_path).to eql taxes_path
    expect(page).to have_content "successfully created"
  end

  scenario "User can't create a tax with invalid data", :js => true, :driver => :webkit do
    visit new_tax_path
    click_on "Save"

    expect(page.current_path).to eql taxes_path
    expect(page).to have_content "3 errors"
  end
end
