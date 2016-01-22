require 'rails_helper'

feature 'Deleting series' do
  scenario 'Delete a series from the listing page' do
    FactoryGirl.create(:series)
    visit '/series/1/edit'
    click_link 'Destroy'
    expect(page).to have_content('Series was successfully destroyed')
    visit '/series'
    expect(page).to have_no_content('Example Series')
  end
end

