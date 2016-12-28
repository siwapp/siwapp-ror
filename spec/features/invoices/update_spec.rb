require "rails_helper"

feature "Invoices:" do
  scenario "User can update an invoice", :js => true, :driver => :webkit do
    invoice = FactoryGirl.create(:invoice)

    visit edit_invoice_path(invoice)
    fill_in "invoice_due_date", with: invoice.issue_date >> 1
    click_on "Save"

    expect(page).to have_content "successfully updated"
  end

  scenario "User can't update an invoice with invalid data", :js => true, :driver => :webkit do
    invoice = FactoryGirl.create(:invoice)

    visit edit_invoice_path(invoice)
    fill_in "invoice_issue_date", with: ""
    click_on "Save"

    expect(page.current_path).to eql invoice_path(invoice)
    expect(page).to have_content "1 error"
  end

  scenario "User can add a new item to an existing invoice", :js => true, :driver => :webkit do
    invoice = FactoryGirl.create(:invoice)

    visit edit_invoice_path(invoice)

    click_on "Add Line"

    within(:xpath, '//*[@id="js-items-table"]/div[2]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Display taxes selector
      within ".tax-selector" do
        find(".btn-group").find("input").click
      end
    end

    # Select VAT tax
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    expect(page).to have_content "$ 10,660.50"

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content("successfully updated")
    expect(page).to have_content "$ 10,660.50"
  end

  scenario "User can add a payment to an invoice", :js => true, :driver => :webkit do
    invoice = FactoryGirl.create(:invoice)

    visit edit_invoice_path(invoice)

    click_on "Add Payment"

    within "#js-payments-table" do
      expect(find_field("Amount").value).to eq "10600"
    end

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content "successfully updated"
    expect(page).to have_content "$ 10,600.00"
    expect(page).to have_content "paid"
  end
end
