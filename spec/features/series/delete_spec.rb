require 'rails_helper'

feature 'Deleting series' do
  scenario 'Delete a series from the listing page', :js => true, driver: :webkit do
    FactoryGirl.create(:series)
    visit '/series/1/edit'
    click_link 'Delete'
    expect(page).to have_content('Series was successfully destroyed')
    visit '/series'
    expect(page).to have_no_content('A- Series')
  end

  scenario 'Delete a series with invoices', :js => true, driver: :webkit do
    invoice = FactoryGirl.create(:invoice)
    series = FactoryGirl.create(:series)
    series.commons << invoice

    visit '/series/1/edit'
    click_link 'Delete'
    visit '/series'
    expect(page).to have_content('A- Series')
  end
end
