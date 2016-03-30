require 'rails_helper'

feature 'Creating Series' do

  before do
    visit '/series'
    first(:link, 'New Series').click
  end

  scenario 'can create a series', :js => true, driver: :webkit do
    fill_in 'Name', with: 'Agro supplies'
    fill_in 'Value', with: 'AGR'
    fill_in 'Next number', with: '3'
    check 'Enabled'

    click_on 'Save'
    expect(page).to have_content('Series was successfully created.')
    expect(page.current_path).to eql(series_index_path)
  end

  scenario 'can not create invoice without value', :js => true, driver: :webkit do
    click_on 'Save'
    expect(page).to have_content("1 error prohibited this series from being saved")
    expect(page).to have_content("Value can't be blank")
  end

end
