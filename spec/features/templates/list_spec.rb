require "rails_helper"

feature "Templates:" do
  background do
    @email_template = FactoryGirl.create(:email_template)
    @print_template = FactoryGirl.create(:print_template)
  end

  scenario "User can see a couple of default templates if no change was made", :js => true, :driver => :webkit do
    visit "/templates"

    expect(page).to have_content("Email Default")
    expect(page).to have_checked_field("email_default_template_#{@email_template.id}")
    expect(page).not_to have_checked_field("print_default_template_#{@email_template.id}")

    expect(page).to have_content("Print Default")
    expect(page).to have_checked_field("print_default_template_#{@print_template.id}")
    expect(page).not_to have_checked_field("email_default_template_#{@print_template.id}")
  end

  scenario "User can change the default template from the list of templates", :js => true, :driver => :webkit do
    visit "/templates"

    find_field("email_default_template_#{@print_template.id}").click

    expect(page).to have_checked_field("print_default_template_#{@print_template.id}")
    expect(page).to have_checked_field("email_default_template_#{@print_template.id}")

    find_field("print_default_template_#{@email_template.id}").click

    expect(page).to have_checked_field("print_default_template_#{@email_template.id}")
    expect(page).to have_checked_field("email_default_template_#{@print_template.id}")
  end

  scenario "User can access the edit template page from the list of templates", :js => true, :driver => :webkit do
    visit "/templates"

    click_link "Print Default"

    expect(page.current_path).to eql edit_template_path(@print_template)
  end
end
