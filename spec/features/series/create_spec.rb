require "rails_helper"

feature "Series:" do

  scenario "User creates a new series", :js => true, :driver => :webkit do
    visit "/series/new"

    fill_in "Name", with: "Agro supplies"
    fill_in "Value", with: "AGR"
    fill_in "First number", with: "3"

    check "Enabled"

    click_on "Save"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("Series was successfully created")
  end

  scenario "User can't create a series without a value", :js => true, :driver => :webkit do
    visit "/series/new"
    click_on "Save"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("1 error prohibited this series from being saved")
    expect(page).to have_content("Value can't be blank")
  end

end
