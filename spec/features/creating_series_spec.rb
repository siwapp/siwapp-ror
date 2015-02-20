require 'rails_helper'

feature 'Creating Series' do

  before do
    visit '/series'
    click_link 'New Serie'
  end

  scenario 'can create a serie' do
    fill_in 'Name', with: 'Agro supplies'
    fill_in 'Value', with: 'AGR'
    fill_in 'First number', with: '3'
    check 'Enabled'

    click_button 'Create Serie'
    expect(page).to have_content('Serie was successfully created.')
    serie = Serie.where(name: 'Agro supplies').first
    expect(page.current_url).to eql(serie_url(serie))
  
    title = "Siwapp - Series - Agro supplies"
    expect(page).to have_title(title)
  end

  scenario 'can not create invoice without value' do
    click_button 'Create Serie'
    expect(page).to have_content("1 error prohibited this serie from being saved")
    expect(page).to have_content("Value can't be blank")
  end



end
