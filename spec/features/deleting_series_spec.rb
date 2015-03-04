require 'rails_helper'

feature 'Deleting series' do
  scenario 'Delete a serie from the listing page' do
    FactoryGirl.create(:serie)
    visit '/series'
    click_link 'Destroy'
    expect(page).to have_content('Serie was successfully destroyed')
    visit '/series'
    expect(page).to have_no_content('Example Series')
  end
end

