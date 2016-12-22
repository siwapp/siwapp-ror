require 'rails_helper'

feature 'Editing Settings' do
  before do
    Rails.cache.clear # settings are cached.
    visit "/settings/global"
  end

  feature 'Global settings editing' do

    before do
      visit '/settings/global'
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

    scenario 'Can not update global settings badly', :js => true, driver: :webkit do
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

  feature 'SMTP settings editing' do

    before do
      visit '/settings/smtp'
    end

    scenario 'Edit smtp settings', :js => true, driver: :webkit do
      fill_in 'Host', with: '127.0.0.1'
      select 'CRAM md5', from: 'smtp_settings_authentication'
      click_on 'Save'
      expect(page).to have_content("SMTP settings successfully saved")
      expect(Settings[:authentication]).to eql 'cram_md5'
      expect(Settings[:host]).to eql '127.0.0.1'
    end

    scenario 'Can not update smtp settings badly', :js => true, driver: :webkit do
      fill_in 'Host', with: 'badomain'
      fill_in 'Port', with: '0'
      click_on 'Save'
      expect(page).to have_content("Host bad format")
      expect(page).to have_content("Port must be greater than 0")
      expect(page).to have_content("SMTP settings couldn't be saved")
      # nothing saved
      expect(Settings[:host]).to be nil # not saved
      expect(Settings[:port]).to be nil # not saved
    end

  end



end
