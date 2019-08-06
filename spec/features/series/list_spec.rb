require "rails_helper"

feature "Series:" do

  scenario "User can mark a series as default from the list of series", :js => true, :driver => :webkit do
    FactoryBot.create_list(:nseries, 3)

    click_on "Account"
    click_on "Series"

    expect(page.current_path).to eql series_index_path

    expect(page).to have_content("A- Series")
    expect(page).to have_content("B- Series")
    expect(page).to have_content("C- Series")

    expect(page).to have_checked_field('default_series_1')   # A-
    expect(page).to have_unchecked_field('default_series_2') # B-
    expect(page).to have_unchecked_field('default_series_3') # C-

    find_field('default_series_2').click

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_unchecked_field('default_series_1') # A-
    expect(page).to have_checked_field('default_series_2')   # B-
  end

end
