require 'rails_helper'

feature 'Creating Taxes' do

  before do
    visit '/taxes'
    first(:link, 'New Tax').click
  end

  scenario 'can create a tax' do
    fill_in 'Name', with: 'IVA'
    fill_in 'Value', with: '15'
    check 'Active'
    check 'Is default'

    click_button 'Create Tax'
    expect(page).to have_content('Tax was successfully created.')
    expect(page.current_url).to eql(taxes_url)
  end

  scenario 'can not create invoice without name' do
    click_button 'Create Tax'
    expect(page).to have_content("Tax has not been created.")
    expect(page).to have_content("Name can't be blank")
  end

end
