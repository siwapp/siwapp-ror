# -*- coding: utf-8 -*-
require 'rails_helper'

feature 'Viewing Items' do
  before do
    invoice = FactoryGirl.create(:invoice, customer_name:"Mate Customer", number:3)
    FactoryGirl.create(:item, common:invoice, description: "Item 1")
    invoice2 = FactoryGirl.create(:invoice, customer_name:"Mate2 Customer", number:2)
    FactoryGirl.create(:item, common:invoice2, description: "Item 2")
    visit '/invoices'
  end
  scenario 'Viewing items for a given invoice' do
    click_link 'XXX-3'
    expect(page).to have_content('Item 1')
    expect(page).to_not have_content('Item 2')
    within("#items li") do
      expect(page).to have_content('Item 1')
    end
  end

end

