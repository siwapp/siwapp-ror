require "rails_helper"

feature "Settings:" do
  before do
    Rails.cache.clear
  end

  scenario "User can configure SMTP settings", :js => true, :driver => :webkit do
    click_on "Account"
    click_on "SMTP Settings"

    expect(page.current_path).to eql settings_smtp_path

    fill_in "smtp_settings_host", with: "127.0.0.1"
    select "CRAM md5", from: "smtp_settings_authentication"
    click_on "Save"

    expect(page.current_path).to eql settings_smtp_path
    expect(page).to have_content "successfully saved"
    expect(Settings[:authentication]).to eql "cram_md5"
    expect(Settings[:host]).to eql "127.0.0.1"
  end

  scenario "Can not update smtp settings badly", :js => true, :driver => :webkit do
    visit settings_smtp_path

    fill_in "smtp_settings_host", with: "badomain"
    fill_in "smtp_settings_port", with: "0"
    click_on "Save"

    expect(page.current_path).to eql settings_smtp_path
    expect(page).to have_content "couldn't be saved"
    expect(Settings[:host]).to be nil # not saved
    expect(Settings[:port]).to be nil # not saved
  end
end
