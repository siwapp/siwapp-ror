require "rails_helper"

feature "Taxes:" do

  scenario "User can create a tax", :js => true, :driver => :webkit do
    visit "/taxes/new"

    fill_in "Name", with: "IVA"
    fill_in "Value", with: "15"

    check "Enabled"
    check "Apply to new items by default"

    click_button "Save"

    expect(page.current_path).to eql(taxes_path)
    expect(page).to have_content("Tax was successfully created")
  end

  scenario "User can't create a tax with invalid data", :js => true, :driver => :webkit do
    visit "/taxes/new"

    click_button "Save"

    expect(page.current_path).to eql(taxes_path)
    expect(page).to have_content("3 errors prohibited this tax from being saved")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Value can't be blank")
    expect(page).to have_content("Value is not a number")
  end

end
