require "rails_helper"

feature "Taxes" do

  scenario "User can mark a tax as default from the list of taxes", :js => true, :driver => :webkit do
    FactoryGirl.create(:tax, default: true)
    FactoryGirl.create(:irpf)

    visit "/taxes"

    expect(page).to have_content("VAT 21%")
    expect(page).to have_content("IRPF -15%")
    expect(page).to have_checked_field('default_tax_1')   # VAT
    expect(page).to have_unchecked_field('default_tax_2') # IRPF

    find_field('default_tax_2').click

    expect(page.current_path).to eql(taxes_path)
    expect(page).to have_checked_field('default_tax_1') # VAT
    expect(page).to have_checked_field('default_tax_2') # IRPF
  end

end
