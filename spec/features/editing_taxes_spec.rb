require 'rails_helper'

feature 'Editing Taxes' do
  before do
    FactoryGirl.create(:tax, name:"Test Tax")
    visit "/taxes"
    click_link "Test Tax"
  end

  scenario 'Updating a Tax', :js => true, driver: :webkit do
    fill_in 'Name', with: 'NEW Test Tax'
    fill_in 'Value', with: '3'
    check 'Enabled'
    click_on 'Save'
    expect(page).to have_content("Tax was successfully updated")
  end

  scenario 'Can not update badly', :js => true, driver: :webkit do
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content('error prohibited this tax from being saved')
  end
end
