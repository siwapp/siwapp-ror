require "rails_helper"

feature "Series:" do
  scenario "User deletes a series", :js => true, :driver => :webkit do
    FactoryGirl.create(:series)

    visit "/series/1/edit"
    click_link "Delete"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("Series was successfully destroyed")
    expect(page).not_to have_content("A- Series")
  end

  scenario "User can't delete a series with invoices", :js => true, :driver => :webkit do
    series = FactoryGirl.create(:series)
    invoice = FactoryGirl.create(:invoice, series: series)

    visit "/series/1/edit"
    click_link "Delete"

    expect(page.current_path).to eql(edit_series_path(series))
    expect(page).to have_content("can not be destroyed")
  end
end
