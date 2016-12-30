require "rails_helper"

feature "Sessions:" do
  scenario "Logged-in users can access protected routes" do
    # Any ApplicationController child controller (except SessionsController)
    # is protected, so we can safely test only of them.
    visit invoices_path
    expect(page.current_path).to eql invoices_path
    visit root_path
    expect(page.current_path).to eql root_path
  end

  scenario "Not-logged users can't access protected routes", :not_logged do
    visit invoices_path
    expect(page.current_path).to eql login_path # where are you going, sailor?
  end
end
