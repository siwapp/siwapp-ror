require 'rails_helper'

RSpec.describe "Api::V1::Invoices", type: :request do

  before do
    Rails.cache.clear
    FactoryGirl.create :token
    FactoryGirl.create :user
    @headers = {'Content-Type' => 'application/json', 
        'Authorization' => 'Token token="123token"'}
    @customer = FactoryGirl.create :customer
  end

  describe 'Invoices show' do
    
    before do
      @series = FactoryGirl.create :series
      @customer = FactoryGirl.create :customer
    end
    
    it 'Show single invoice with details' do
      invoice = FactoryGirl.create :invoice, customer: @customer
      get api_v1_invoice_path(invoice), nil, @headers
      expect(response).to be_success
      expect(json['items'].length).to eql 3
      expect(json['items'][0]['url']).to eql api_v1_item_url(invoice.items[0])
      expect(json['customer']['url']).to eql api_v1_customer_url(@customer)
    end
  end

  describe "Invoices Listing" do
    it "Standard listing works ok" do

      invoice = FactoryGirl.create :invoice, customer: @customer 

      get api_v1_invoices_path, nil, @headers

      expect(response).to be_success
      expect(json.is_a? Array).to be true
      expect(json[0]['name']).to eql 'Example Customer Name'
    end

    describe "Paginated invoicies listing" do
      before do
        invoice = FactoryGirl.create_list :invoice, 30, customer: @customer
      end

      it "Display only 20 results per page" do
        get api_v1_invoices_path, nil, @headers
        expect(response).to be_success
        expect(json.count).to eql 20
      end

      it "'Page' param sets the page" do
        get api_v1_invoices_path, {page: 2},  @headers
        expect(response).to be_success
        expect(json.count).to eql 10
      end
    end
  end

  describe "Invoice creation" do
    
    before do
      @series = FactoryGirl.create :series
    end

    it "basic invoice creation on POST requeset" do
      inv = { 
        'invoice' => {
          'name' => 'newly created',
          'email' => 'test@email.com',
          'issue_date' => '2016-06-06',
          'series_id' => @series.id
        }
      }
      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 201 # created resource
      expect(json['name']).to eql 'newly created'
      expect(Invoice.find(json['id']).name).to eql 'newly created'
    end

    it "can create invoice along with items" do
      tax = FactoryGirl.create :tax
      
      inv = {
        'invoice' => {
          'name' => 'newly created',
          'email' => 'test@email.com',
          'issue_date' => '2016-06-06',
          'series_id' => @series.id,
          'items_attributes' => [
                                 {
                                   'description': 'item 1',
                                   'unitary_cost': 3.3,
                                   'quantity': 2,
                                   'tax_ids': [tax.id]
                                 }
                                ]
        }
      }

      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 201
      invoice = Invoice.find(json['id']) 
      item = invoice.items[0]
      expect(item.description).to eql 'item 1'
      expect(item.taxes[0].name).to eql 'VAT 21%'

    end

    it "proper invalidation messages" do
      inv = {
        'invoice' => {
          'name' => 'bogus',
          'issue_date' => '2015-05-05',
          'email' => 'test@bemail.com'
        }
      }
      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 422 # unprocessable entity
    end

  end

  describe 'Invoice updating' do
    
    before do
      @series = FactoryGirl.create :series
      @invoice = FactoryGirl.create :invoice, customer: @customer
    end
    
    it "basic invoice updating" do

       put api_v1_invoice_path(@invoice), {'invoice':{'name': 'modified'}}.to_json, @headers

      expect(response.status).to eql 200
      expect(json['name']).to eql 'modified'
    end

  end

  describe 'Invoice deleting' do
    before do
      @series = FactoryGirl.create :series
      @invoice = FactoryGirl.create :invoice, customer: @customer
    end

    it 'basic invoice deleting' do
      delete api_v1_invoice_path(@invoice), nil, @headers
      expect(response.status).to eql 204 # deleted resoource
      expect(Invoice.find_by_id(@invoice.id)).to be_nil
    end
  end


end
