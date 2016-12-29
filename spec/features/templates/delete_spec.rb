require "rails_helper"

feature "Templates:" do
  background do
    @template = FactoryGirl.create(:print_template)
  end

  scenario "User can delete an existing template", :js => true, :driver => :webkit do
    visit "/templates/1/edit"

    accept_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eql templates_path
    expect(page).not_to have_content("My Awesome Template (modified)")
  end
end
