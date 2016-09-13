require 'rails_helper'

feature 'Editing Global Settings' do
  before do
    Rails.cache.clear # settings are cached.
    visit "/settings/global"
  end

  scenario 'Edit global settings', :js => true, driver: :webkit do
    fill_in 'Company Name', with: 'NEW Company Name'
    fill_in 'Company Email', with: 'bad@company.com'
    select 'USD', from: 'global_settings_currency'
    click_on 'Save'
    expect(page).to have_content("Global settings successfully saved")
    expect(Settings[:currency]).to eql 'usd'
    expect(Settings[:company_email]).to eql 'bad@company.com'
  end

  scenario 'Can not update badly', :js => true, driver: :webkit do
    fill_in 'Days to due', with: ''
    fill_in 'Company Email', with: 'bad@email.c'
    click_on 'Save'
    expect(page).to have_content("Company email bad format")
    expect(page).to have_content("Days to due is not a number")
    expect(page).to have_content(' Global settings could not be saved')
    # nothing saved
    expect(Settings[:days_to_due]).to eql 0 # the default setting
    expect(Settings[:company_email]).to be nil # no saved
  end
end
