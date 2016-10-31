require 'rails_helper'


RSpec.describe "Api::V1::Items", type: :request do

  before do
    Rails.cache.clear
    FactoryGirl.create :token
    FactoryGirl.create :user
    @headers = {'Content-Type' => 'application/json', 
        'Authorization' => 'Token token="123token"'}
    @customer = FactoryGirl.create(:customer, name: "Test Customer")
    @series = FactoryGirl.create :series
    @invoice = FactoryGirl.create :invoice, customer: @customer
    @item = @invoice.items[0]
  end

  describe "Items show" do
    it 'GET /api/v1/items/:id show single item with details' do
      get api_v1_item_path(@item), nil, @headers
      expect(response).to be_success
      # invoice reference
   #   expect(json['data']['relationships']['invoice']['links']['related']).to eql api_v1_invoice_url(@invoice)
      # taxes
   #   expect(json['data']['relationships']['taxes']['data'][0]['attributes']['name']).to eql 'VAT 21%'
   #   expect(json['data']['relationships']['taxes']['data'][0]['attributes']['links']['related']).to eql api_v1_tax_url(@item.taxes[0])
    end
  end

  describe "Items listings" do
    it 'GET /api/v1/invoices/:invoice_id/items provde listing' do
      get api_v1_invoice_items_path(@invoice.id), nil, @headers
      expect(response).to be_success
      expect(json["data"].length).to eql 3 # 3 items
      expect(json["data"][0]["relationships"]['invoice']).to be_nil
      expect(json["data"][0]["relationships"]['taxes']).to eql api_v1_item_taxes_url(@item)
    end
  end

  describe "Item creation" do

    before do
      @taxes = Tax.all
    end

    it 'POST /api/v1/invoices/:invoice_id/items with taxes_id and taxes names' do
      item = {
        'data' => {
          'attributes' => {
            'description' => 'brand new item',
            'quantity' => 2,
            'tax_ids' => [@taxes[0].id]
          }
        }
      }
      post api_v1_invoice_items_path(@invoice), item.to_json, @headers
      expect(response).to have_http_status :created
      expect(json['data'][0]['attributes']['tax_ids'][0]).to eql @taxes[0].id # tax assignment by id
      # expect(json['data'][1]['attributes']['name']).to eql 'RETENTION' # tax assignment by name
      # db, too
      expect(Item.find(json['id']).description).to eql 'brand new item'
    end
  end

  describe "Item updating" do
    
    before do
      @taxes = Tax.all
    end
    
    it 'PUT /api/v1/items/:id' do
      mod = {'data'=> {'attributes' => {'quantity'=>33, 'tax_ids'=>[@taxes[2].id]}}}
      put api_v1_item_path(@item), mod.to_json, @headers
      expect(response).to have_http_status :ok
      expect(json['data']['attributes']['quantity']).to eql '33.0' 
      expect(json['data']['attributes']['tax_ids'][0]).to eql @taxes[2].id
      item = Item.find @item.id
      # the db, too
      expect(item.taxes[0].id).to eql @taxes[2].id
    end
  end

  describe "Item deletion" do
    
    it 'DELETE /api/v1/items/:id' do
      delete api_v1_item_path(@item), nil, @headers
      expect(response).to have_http_status :no_content
      expect(Item.find_by_id(@item.id)).to be_nil
    end
  end

  

end
