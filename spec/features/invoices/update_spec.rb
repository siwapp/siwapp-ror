require "rails_helper"

feature "Invoices:" do
  scenario "User can update an invoice", :js => true, :driver => :webkit do
    FactoryBot.create(:b_series)
    invoice = FactoryBot.create(:invoice)

    expect(invoice.number).to eq 1

    visit edit_invoice_path(invoice)
    fill_in "invoice_due_date", with: invoice.issue_date >> 1

    # Also update the item
    within(:xpath, '//*[@id="js-items-table"]/div[1]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Display taxes selector
      within ".invoice-col--taxes" do
        first(".select2-selection__choice__remove").click
        first(".select2-selection__choice__remove").click
      end
    end

    expect(page).to have_content "$ 50.00"

    # Add some tags
    tags_selector = find('[data-role="tagging"]+.select2')
    tags_selector.click
    within tags_selector do
      find('input').set "Projects,Web,"
    end

    # Add some meta
    within :xpath, '//*[@id="js-meta-table"]/div[1]' do
      fill_in('key[]', with: 'code')
      fill_in('value[]', with: 'AREA51')
    end

    click_on "Add Attribute"

    within :xpath, '//*[@id="js-meta-table"]/div[2]' do
      fill_in('key[]', with: 'discount')
      fill_in('value[]', with: '0')
    end

    # Test that number dissappears if series changes

    select "B- Series", from: "invoice_series_id"
    wait_for_ajax
    expect(page).not_to have_field "invoice_number"

    # But it's reverted to the original value if the series is reset

    select "A- Series", from: "invoice_series_id"
    expect(find_field("invoice_number").value).to eq "1"

    click_on "Save"

    expect(page).to have_content "successfully updated"

    invoice.reload

    expect(invoice.tag_list.length).to eql 2
    expect(invoice.tag_list).to eq %w(Web Projects)
    expect(invoice.get_meta("code")).to eq "AREA51"
    expect(invoice.get_meta("discount")).to eq "0"
  end

  scenario "User can't update an invoice with invalid data", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)
    fill_in "invoice_issue_date", with: ""
    click_on "Save"

    expect(page.current_path).to eql invoice_path(invoice)
    expect(page).to have_content "1 error"
  end

  scenario "User can add a new item to an existing invoice", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)

    find('.add_fields', text: 'Add Line').trigger('click')

    within(:xpath, '//*[@id="js-items-table"]/div[2]') do
      fill_in "Description", with: "Support"
      fill_in "Quantity", with: "1"
      fill_in "Price", with: "50"

      # Display taxes selector
      within ".invoice-col--taxes" do
        find("label").trigger('click')
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
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)

    click_on "Add Payment"
    sleep 1  # weird fix to make it work on docker
    within "#js-payments-table" do
      expect(find_field("Amount").value).to eq "10600"
    end

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content "successfully updated"
    expect(page).to have_content "$ 10,600.00"
    expect(page).to have_content "paid"
  end

  scenario "User can remove payments and items from an invoice", :js => true, :driver => :webkit do
    invoice = FactoryBot.create(
      :invoice,
      items: [
        Item.new(quantity: 1, unitary_cost: 20),
        Item.new(quantity: 1, unitary_cost: 10)
      ],
      payments: [
        Payment.new(amount: 10, date: Date.current),
        Payment.new(amount: 10, date: Date.current)
      ]
    )

    visit edit_invoice_path(invoice)

    expect(page).to have_content "$ 30.00"

    within :xpath, '//*[@id="js-items-table"]/div[1]' do
      click_on 'delete'
    end

    within :xpath, '//*[@id="js-payments-table"]/div[1]' do
      click_on 'delete'
    end

    expect(page).to have_content "$ 10.00"

    click_on "Save"

    expect(page.current_path).to eql invoices_path
    expect(page).to have_content "successfully updated"
    expect(page).to have_content "$ 10.00"
    expect(page).to have_content "paid"
  end

end
