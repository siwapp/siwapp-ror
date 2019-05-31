require "rails_helper"

feature "Taxes:" do
  scenario "User can delete a a tax", :js => true, :driver => :webkit do
    vat = FactoryBot.create(:vat)

    visit edit_tax_path(vat)

    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eql taxes_path
    expect(page).to have_content "successfully deleted"
    expect(page).not_to have_content "VAT"
  end

  scenario "User can't delete a tax associated with an item", :js => true, :driver => :webkit do
    FactoryBot.create(:invoice)
    vat = Tax.find_by(id: 1)

    visit edit_tax_path(vat)
    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eql edit_tax_path(vat)
    expect(page).to have_content "Can't delete"
  end
end
