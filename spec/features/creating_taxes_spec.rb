require 'rails_helper'

feature 'Creating Taxes' do

  before do
    visit '/taxes'
    first(:link, 'New Tax').click
  end

  scenario 'can create a tax', :js => true, driver: :webkit do
    fill_in 'Name', with: 'IVA'
    fill_in 'Value', with: '15'
    check 'Active'
    check 'Default'

    click_button 'Save'
    expect(page).to have_content('Tax was successfully created.')
    expect(page.current_path).to eql(taxes_path)
  end

  scenario 'can not create invoice without name', :js => true, driver: :webkit do
    click_button 'Save'
    expect(page).to have_content("Tax has not been created.")
    expect(page).to have_content("Name can't be blank")
  end

end
