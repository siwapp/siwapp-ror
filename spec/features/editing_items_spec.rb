# -*- coding: utf-8 -*-
require 'rails_helper'

feature 'Editing Items' do
  
  let!(:invoice) {FactoryGirl.create(:invoice)}
  let!(:item) {FactoryGirl.create(:item, common:invoice)}

  before do
    visit '/invoices'
    click_link "XXX-#{invoice.number}"
    click_link item.description
    click_link 'Edit'
  end

  scenario 'Updating an Item' do
    fill_in 'Description', with: 'Im a new description, you moron'
    click_button 'Update Item'
    expect(page).to have_content("Item was successfully updated.")
    within('#item h2') do
      expect(page).to have_content('Im a new description, you moron')
    end
    expect(page).to_not have_content(invoice.customer_name)
  end

  scenario 'Updating an Item with invalid information' do
    fill_in 'Description', with: ''
    click_button 'Update Item'
    expect(page).to have_content('Item has not been updated.')
  end

end
