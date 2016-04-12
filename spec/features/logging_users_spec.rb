require 'rails_helper'

feature 'Logged users' do

  scenario 'can access anywhere' do
    visit '/customers'
    expect(page.current_path).to eql customers_path
    visit '/recurring_invoices'
    expect(page.current_path).to eql recurring_invoices_path
    visit '/'
    expect(page.current_path).to eql root_path
  end

  scenario 'and of course can log out' do
    first(:link, 'Log out').click
    expect(page.current_path).to eql login_path
    visit '/invoices'
    expect(page.current_path).to eql login_path # where are you going, sailor?
  end

end
