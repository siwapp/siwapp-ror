require "rails_helper"

feature "Invoices:" do
  background do
    # load templates
    Rails.application.load_seed
  end

  scenario "User will see a preview of a paid invoice inside an iframe an can download a PDF", js: true, driver: :webkit do
    invoice = FactoryGirl.create(:invoice, :paid)

    visit invoices_path
    click_link invoice.to_s

    expect(page).to have_xpath("//iframe")
    expect(page).to have_link("Download PDF")

    click_on "Download PDF"

    expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"#{invoice.to_s}.pdf\""
    expect(page.response_headers["Content-Type"]).to eq "application/pdf"
  end

  scenario "Template url shows template", js: true, driver: :webkit do
    invoice = FactoryGirl.create(:invoice, :paid)

    visit print_invoice_path(invoice)

    expect(page).to have_content("Billed:")
  end
end
