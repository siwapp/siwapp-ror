require "rails_helper"

feature "Recurring Invoices:" do

  scenario "User can create a recurring invoice. A Customer is created.", :js => true, :driver => :webkit do
    FactoryBot.create(:series, :default)
    FactoryBot.create(:vat)
    FactoryBot.create(:retention)

    visit new_recurring_invoice_path

    fill_in "recurring_invoice_name", with: "Test Customer"
    fill_in "recurring_invoice_identification", with: "12345"
    fill_in "recurring_invoice_email", with: "test@customer.com"
    fill_in "recurring_invoice_invoicing_address", with: "Fake Address"

    click_link "Copy Invoicing Address"
    expect(find_field("recurring_invoice_shipping_address").value).to eq "Fake Address"

    expect(page).to have_checked_field("recurring_invoice_enabled")

    fill_in "recurring_invoice_days_to_due", with: "30"
    fill_in "recurring_invoice_starting_date", with: Date.current >> 1
    fill_in "recurring_invoice_period", with: "1"
    select "Monthly", from: "recurring_invoice_period_type"

    select "A- Series", from: "recurring_invoice_series_id"

    # Fill in the only item line available
    within(:xpath, '//*[@id="js-items-table"]/div[1]') do
      fill_in "Description", with: "Work"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "100"

      # Check that taxes selector works for the default item...
      within ".invoice-col--taxes" do
        find("label").click
      end
    end

    # ... by adding VAT
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    click_on "Add Line"

    # Fill in the new item line created
    within(:xpath, '//*[@id="js-items-table"]/div[2]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Check that taxes selector works for the new item
      within ".invoice-col--taxes" do
        find("label").click
      end
    end

    # ... by adding VAT
    within ".select2-dropdown" do
      within ".select2-results__options" do
        find(".select2-results__option", :text => "VAT").click
      end
    end

    expect(page).to have_content "$ 181.50"

    click_on "Save"

    expect(page.current_path).to eql recurring_invoices_path
    expect(page).to have_content("successfully created.")
    expect(page).to have_content "$ 181.50"

    expect(Customer.find_by(email: "test@customer.com", identification: "12345")).not_to be nil
  end

  scenario "User can't create a recurring invoice with invalid data", :js => true, :driver => :webkit do
    visit new_recurring_invoice_path
    click_on "Save"

    expect(page.current_path).to eql recurring_invoices_path
    expect(page).to have_content "6 errors"
  end
end
