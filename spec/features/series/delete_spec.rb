require "rails_helper"

feature "Series" do

  background do
    @series = FactoryGirl.create(:series)
  end

  scenario "User deletes a series", :js => true, :driver => :webkit do
    visit "/series/1/edit"
    click_link "Delete"

    expect(page).to have_content("Series was successfully destroyed")
    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_no_content("A- Series")
  end

  scenario "User can't delete a series with invoices", :js => true, :driver => :webkit do
    invoice = FactoryGirl.create(:invoice, series: @series)

    visit "/series/1/edit"
    click_link "Delete"

    expect(page).to have_content("Series has invoices and can not be destroyed")
    expect(page.current_path).to eql(edit_series_path(@series))
  end

end
