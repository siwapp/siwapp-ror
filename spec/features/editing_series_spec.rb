require 'rails_helper'

feature 'Editing Series' do
  before do
    FactoryGirl.create(:serie, name: "Test Serie")
    visit "/series"
    click_link "Test Serie"
    click_link "Edit"
  end

  scenario 'Updating a Serie' do
    fill_in 'Name', with: 'NEW Test Serie'
    fill_in 'Value', with: 'NTS'
    fill_in 'Next number', with: '3'
    check 'Enabled'
    click_button 'Update Serie'
    expect(page).to have_content("Serie was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Value', with: ''
    click_button 'Update Serie'
    expect(page).to have_content("Value can't be blank")
    expect(page).to have_content('error prohibited this serie from being saved')
  end
end

