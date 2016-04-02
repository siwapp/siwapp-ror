require 'rails_helper'

feature 'PDF of Invoices' do
  before do
    Rails.application.load_seed # loading seeds to get the template
    FactoryGirl.create(:invoice)
    FactoryGirl.create(:template)
    visit "/invoices"
    click_link "ES-1"
  end

  scenario 'Show of a paid invoice show the iframe', js: true, driver: :webkit do
    expect(page).to have_xpath("//iframe")
    expect(page).to have_link("PDF")
    click_on "PDF"
    expect(page.response_headers['Content-Disposition']).to eq 'attachment; filename="ES-1.pdf"'
    expect(page.response_headers['Content-Type']).to eq 'application/pdf'
  end

  scenario 'Template url shows template', js: true, driver: :webkit do
    visit "/invoices/template/1/invoice/1"
    expect(page).to have_content("BILLED ON")
  end
end
