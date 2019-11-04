require "rails_helper"

feature "Settings:" do
  before do
    Rails.cache.clear
  end

  scenario "User can configure global settings", :js => true, :driver => :webkit do
    click_on "Account"
    click_on "Global Settings"

    expect(page.current_path).to eql settings_global_path

    fill_in "global_settings_company_name", with: "My Company"
    fill_in "global_settings_company_email", with: "my@company.com"
    select "USD", from: "global_settings_currency"
    click_on "Save"

    expect(page.current_path).to eql settings_global_path
    expect(page).to have_content "successfully saved"
    expect(Settings.company_name).to eql "My Company"
    expect(Settings.company_email).to eql "my@company.com"
    expect(Settings.currency).to eql "usd"
  end

  scenario "Can't configure global settings with invalid data", :js => true, :driver => :webkit do
    visit settings_global_path

    fill_in "global_settings_days_to_due", with: ""
    fill_in "global_settings_company_email", with: "bad@email.c"

    click_on "Save"

    expect(page.current_path).to eql settings_global_path
    expect(page).to have_content "Global settings could not be saved"

    # nothing saved
    expect(Settings.days_to_due).to eql 0 # default setting
    expect(Settings.company_email).to be nil # not saved
  end
end
