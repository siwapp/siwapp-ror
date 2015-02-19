require 'rails_helper'

feature 'Editing Taxes' do
  before do
    FactoryGirl.create(:tax, name:"Test Tax")
    visit "/taxes"
    click_link "Test Tax"
    click_link "Edit"
  end

  scenario 'Updating a Tax' do
    fill_in 'Name', with: 'NEW Test Tax'
    fill_in 'Value', with: '3'
    check 'Active'
    click_button 'Update Tax'
    expect(page).to have_content("Tax was successfully updated")
  end

  scenario 'Can not update badly' do
    fill_in 'Name', with: ''
    click_button 'Update Tax'
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content('error prohibited this tax from being saved')
  end
end

