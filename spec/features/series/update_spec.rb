require "rails_helper"

feature "Series:" do
  scenario "User can update a series", :js => true, :driver => :webkit do
    FactoryGirl.create(:series)

    visit "/series/1/edit"

    fill_in "Name", with: "B- Series"
    fill_in "Value", with: "B-"
    fill_in "First number", with: "2"

    check "Enabled"

    click_on "Save"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("Series was successfully updated")
  end

  scenario "User can't update a series with invalid data", :js => true, :driver => :webkit do
    series = FactoryGirl.create(:series)

    visit "/series/1/edit"

    fill_in "Value", with: ""

    click_on "Save"

    expect(page.current_path).to eql(series_path(series))
    expect(page).to have_content("1 error prohibited this series from being saved")
    expect(page).to have_content("Value can't be blank")
  end
end
