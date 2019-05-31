require "rails_helper"

feature "Invoices:" do
  background do
    Rails.application.load_seed

    @invoice = FactoryBot.create(:invoice, :paid)
  end

  scenario "User will see a preview of a paid invoice inside an iframe an can download a PDF", js: true, driver: :webkit do
    visit invoices_path
    click_link @invoice.to_s

    expect(page.current_path).to eql invoice_path(@invoice)
    expect(page).to have_xpath("//iframe")
    expect(page).to have_link("Download PDF")

    click_on "Download PDF"

    expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"#{@invoice.to_s}.pdf\""
    expect(page.response_headers["Content-Type"]).to eq "application/pdf"
  end

  scenario "Template url shows template", js: true, driver: :webkit do
    visit print_invoice_path(@invoice)
    expect(page).to have_content("Billed:")
  end

  scenario "User can access the edit page from the print preview page", :js => true, :driver => :webkit do
    visit invoice_path(@invoice)
    click_on "Edit"
    expect(page.current_path).to eq edit_invoice_path(@invoice)
  end

  scenario "User can download selected invoices as PDF from the invoices list", :js => true, :driver => :webkit do
    visit invoices_path

    find_field('select_all').click
    click_on "Download PDF"
	sleep 2

    expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"invoices.pdf\""
    expect(page.response_headers["Content-Type"]).to eq "application/pdf"
  end
end
