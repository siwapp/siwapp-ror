require "rails_helper"

feature "Series:" do
  scenario "User deletes a series", :js => true, :driver => :webkit do
    series = FactoryBot.create(:series)

    visit edit_series_path(series)

    accept_confirm do
      click_link "Delete"
    end

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("successfully destroyed")
    expect(page).not_to have_content("A- Series")
  end

  scenario "User can't delete a series with invoices", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)
    series = invoice.series

    visit edit_series_path(series)
    accept_confirm do
      click_link "Delete"
    end

    expect(page.current_path).to eql(edit_series_path(series))
    expect(page).to have_content("can not be destroyed")
  end
end
