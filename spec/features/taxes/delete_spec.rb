require "rails_helper"

feature "Taxes:" do
  scenario "User can delete a a tax", :js => true, :driver => :webkit do
    FactoryGirl.create(:tax)

    visit "/taxes/1/edit"

    click_link "Delete"

    expect(page.current_path).to eql taxes_path
    expect(page).to have_content("Tax was successfully deleted")
    expect(page).to have_no_content("VAT 21%")
  end

  scenario "User can't delete a tax associated with an item" do
    FactoryGirl.create(:invoice)
    tax = Tax.find_by(value: 21)

    visit "/taxes/#{tax.id}/edit"
    click_link "Delete"

    expect(page.current_path).to eql edit_tax_path(tax)
    expect(page).to have_content("Can't delete")
  end
end
