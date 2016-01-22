require 'rails_helper'

feature 'Creating Series' do

  before do
    visit '/series'
    first(:link, 'New Series').click
  end

  scenario 'can create a series' do
    fill_in 'Name', with: 'Agro supplies'
    fill_in 'Value', with: 'AGR'
    fill_in 'Next number', with: '3'
    check 'Enabled'

    click_button 'Create Series'
    expect(page).to have_content('Series was successfully created.')
    expect(page.current_url).to eql(series_index_url)
  end

  scenario 'can not create invoice without value' do
    click_button 'Create Series'
    expect(page).to have_content("1 error prohibited this series from being saved")
    expect(page).to have_content("Value can't be blank")
  end

end
