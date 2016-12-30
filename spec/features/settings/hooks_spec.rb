require "rails_helper"

feature "Settings:" do
  background do
    Rails.cache.clear
  end

  scenario "User can set a URL to be called when a new recurring invoice is generated", :js => true, :driver => :webkit do
    click_on "Account"
    click_on "Hooks"

    expect(page.current_path).to eql settings_hooks_path

    fill_in "hooks_settings_event_invoice_generation_url", with: "http://www.example.com/hook"
    click_on "Save"

    expect(page.current_path).to eql settings_hooks_path
    expect(find_field("hooks_settings_event_invoice_generation_url").value).to eql "http://www.example.com/hook"
  end

  scenario "User can't set a hook URL with invalid data", :js => true, :driver => :webkit do
    visit settings_hooks_path

    fill_in "hooks_settings_event_invoice_generation_url", with: "hook"
    click_on "Save"

    expect(page.current_path).to eql settings_hooks_path
    expect(page).to have_content "1 error"
  end
end
