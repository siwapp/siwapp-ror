require "rails_helper"

feature "Taxes:" do
  scenario "User can mark a tax as default from the list of taxes", :js => true, :driver => :webkit do
    FactoryBot.create(:vat, default: true)
    FactoryBot.create(:retention)

    click_on "Account"
    click_on "Taxes"

    expect(page.current_path).to eql taxes_path

    expect(page).to have_content "VAT"
    expect(page).to have_content "RETENTION"
    expect(page).to have_checked_field "default_tax_1"   # VAT
    expect(page).to have_unchecked_field "default_tax_2" # RETENTION

    find_field("default_tax_2").click

    expect(page.current_path).to eql taxes_path
    expect(page).to have_checked_field "default_tax_1" # VAT
    expect(page).to have_checked_field "default_tax_2" # RETENTION
  end
end
