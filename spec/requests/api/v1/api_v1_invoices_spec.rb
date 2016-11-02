require 'rails_helper'

RSpec.describe "Api::V1::Invoices", type: :request do

  before do
    Rails.cache.clear
    FactoryGirl.create :token
    FactoryGirl.create :user
    @template = FactoryGirl.create :template
    @headers = {'Content-Type' => 'application/json', 
        'Authorization' => 'Token token="123token"'}
    @customer = FactoryGirl.create(:customer, name: "Test Customer")
    @series = FactoryGirl.create :series
    @invoice = FactoryGirl.create :invoice, customer: @customer
  end

  describe 'Invoices show' do
    
    it 'GET /api/v1/invoices/:id Show single invoice with details' do
      get api_v1_invoice_path(@invoice), nil, @headers
      expect(response).to be_success
      expect(json['data'].length).to eql 4
    # TODO(@ecoslado) Put the nested object's links
    #  expect(json['data'][0]['links']['self']).to eql api_v1_item_url(@invoice.items[0])
    #  expect(json['data']['relationships']['customer']['links']['related']).to eql api_v1_customer_url(@customer)
    # download link
      expect(json['data']['attributes']['download-link']).to eql api_v1_rendered_template_path(@template, @invoice)
    end
  end

  describe "Invoices Listing" do
    it "GET /api/v1/invoices Standard listing works ok" do

      get api_v1_invoices_path, nil, @headers

      expect(response).to be_success
      expect(json['data'].is_a? Array).to be true
      expect(json['data'][0]['attributes']['name']).to eql 'Example Customer Name'
    end

    describe "Paginated invoicies listing" do

      before do
        FactoryGirl.create_list :invoice, 30, customer: @customer # 30 more invoices
      end

      it "Display only 20 results per page and return pagination headers" do
        get api_v1_invoices_path, nil, @headers
        expect(response).to be_success
        expect(json['data'].count).to eql 20
        expect(response.headers).to have_key 'X-Pagination'
        pagination_header = JSON.parse response.headers['X-Pagination']
        expect(pagination_header['total']).to eql 31
        expect(pagination_header['next_page']).to eql 2
      end

      it "'Page' param sets the page" do
        get api_v1_invoices_path, {page: 2},  @headers
        expect(response).to be_success
        expect(json['data'].count).to eql 11
      end
    end
  end

  describe "Invoice creation" do
    
    it "basic invoice creation on POST request" do
      inv = { 
        'data' => {
          'attributes' => {
          'name' => 'newly created',
          'email' => 'test@email.com',
          'issue_date' => '2016-06-06',
          'series_id' => @series.id
        }
      }
      }
      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 201 # created resource
      expect(json['data']['attributes']['name']).to eql 'newly created'
      expect(Invoice.find(json['data']['id']).name).to eql 'newly created'
    end

    it "can create invoice along with items and payments" do
      tax = FactoryGirl.create :tax
      
      inv = {
        'data' => {
          'type' => 'invoices',
          'attributes' => {
            'name' => 'newly created',
            'email' => 'test@email.com',
            'issue_date' => '2016-06-06',
            'series_id' => @series.id
          },
          'relationships' => {
            'items' => {
              'data' => [
                {'attributes' => {
                  'description' => 'item 1',
                  'unitary_cost'=> 3.3,
                  'quantity' => 2,
                  'tax_ids' => [tax.id]
                  }
                }]},
            'payments' => {
              'data' => [{
                'attributes' => {
                  'notes' => 'payment 1',
                  'amount' => 3.3,
                  'date' => '2016-02-02'
                }
              }]
            }
          }
        }
      }

      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 201
      invoice = Invoice.find(json['data']['id']) 
      item = invoice.items[0]
      expect(item.description).to eql 'item 1'
      expect(item.taxes[0].name).to eql 'VAT 21%'
      payment = invoice.payments[0]
      expect(payment.notes).to eql 'payment 1'
      expect(payment.amount).to eql 3.3

    end

    it "proper invalidation messages" do
      inv = {
        'data' => {
          'type' => 'invoices',
          'attributes' => {
            'name' => 'bogus',
            'issue_date' => '2015-05-05',
            'email' => 'test@bemail.com'
          }
          
        }
      }
      post api_v1_invoices_path, inv.to_json, @headers
      expect(response.status).to eql 422 # unprocessable entity
    end

  end

  describe 'Invoice updating' do
    
    it "basic invoice updating" do
      put api_v1_invoice_path(@invoice), {'data':{'attributes': {'name': 'modified'}}}.to_json, @headers
      expect(response.status).to eql 200
      expect(json['data']['attributes']['name']).to eql 'modified'
    end

  end

  describe 'Invoice deleting' do

    it 'basic invoice deleting' do
      delete api_v1_invoice_path(@invoice), nil, @headers
      expect(response.status).to eql 204 # deleted resoource
      expect(Invoice.find_by_id(@invoice.id)).to be_nil
    end
  end


end
