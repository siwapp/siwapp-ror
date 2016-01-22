require 'rails_helper'

feature 'Editing Series' do
  before do
    FactoryGirl.create(:series, name: "Test Series")
    visit "/series"
    click_link "Test Series"
  end

  scenario 'Updating a Series' do
    fill_in 'Name', with: 'NEW Test Series'
    fill_in 'Value', with: 'NTS'
    fill_in 'Next number', with: '3'
    check 'Enabled'
    click_button 'Update Series'
    expect(page).to have_content("Series was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Value', with: ''
    click_button 'Update Series'
    expect(page).to have_content("Value can't be blank")
    expect(page).to have_content('error prohibited this series from being saved')
  end
end

