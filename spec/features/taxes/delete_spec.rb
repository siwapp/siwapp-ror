require "rails_helper"

feature "Taxes:" do
  scenario "User can delete a a tax", :js => true, :driver => :webkit do
    vat = FactoryGirl.create(:vat)

    visit edit_tax_path(vat)

    click_link "Delete"

    expect(page.current_path).to eql taxes_path
    expect(page).to have_content("Tax was successfully deleted")
    expect(page).not_to have_content("VAT")
  end

  scenario "User can't delete a tax associated with an item" do
    FactoryGirl.create(:invoice)
    vat = Tax.find_by(id: 1)

    visit edit_tax_path(vat)
    click_link "Delete"

    expect(page.current_path).to eql edit_tax_path(vat)
    expect(page).to have_content("Can't delete")
  end
end
