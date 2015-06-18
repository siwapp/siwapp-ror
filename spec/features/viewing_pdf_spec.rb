require 'rails_helper'

feature 'PDF of Invoices' do
  before do
    FactoryGirl.create(:invoice)
    FactoryGirl.create(:template)
    visit "/invoices"
    click_link "ES-1"
  end

  scenario 'Show of a paid invoice show the iframe' do
    expect(page).to have_xpath("//iframe")
    expect(page).to have_link("PDF")
  end
  
  scenario 'Template url shows template' do
    visit "/invoices/template/1/invoice/1"
    expect(page).to have_content("fake template")
  end
    
end

