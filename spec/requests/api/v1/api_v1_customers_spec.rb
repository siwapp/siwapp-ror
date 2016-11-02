require 'rails_helper'

RSpec.describe "Api::V1::Payments", type: :request do

  before do
    Rails.cache.clear
    FactoryGirl.create :token
    FactoryGirl.create :user
    @headers = {'Content-Type' => 'application/json', 
        'Authorization' => 'Token token="123token"'}
    @customer = FactoryGirl.create(:customer, name: "Test Customer")
    @series = FactoryGirl.create :series
    @invoice = FactoryGirl.create :invoice, customer: @customer
  end

  describe "Customers show" do
    it 'GET /api/v1/customers/:id show customer with details' do
      get api_v1_customer_path(@customer), nil, @headers
      expect(response).to be_success
      expect(json['data']['type']).to eql 'customers'
      expect(json['data']['attributes']['name']).to eql @customer.name
    end

    it 'GET /api/v1/customers/:id/invoices shows filtered invoices' do
      # create extra invoice for another customer
	  alt_customer = FactoryGirl.create(:customer, name: "Alt Customer")
      alt_invoice = FactoryGirl.create :invoice, customer: alt_customer
      print_template = FactoryGirl.create :template, print_default: true, name: "print default", template: ""
      get api_v1_customer_invoices_path(@customer), nil, @headers
      expect(response).to be_success
      expect(json['data'].length).to eql 1 # only @invoice, not alt_invoice
      expect(json['data'][0]['id']).to eql @invoice.id.to_s
    end
  end

  describe "Custoners listing" do
    it 'GET /api/v1/customers' do
      get api_v1_customers_path, nil, @headers
      expect(response).to be_success
      expect(json['data'].length).to eql 1
      expect(json['data'][0]['attributes']['name']).to eql @customer.name
    end
  end

  describe 'Customer creation' do
    it 'POST /api/v1/customers' do
      cust = {
        'data' => {
          'type' => 'customers',
          'attributes' => {
            'name' => 'cust name',
            'identification' => 'X-1234',
            'email' => 'test@example.com'
          }
        }
      }
      post api_v1_customers_url, cust.to_json, @headers
      expect(response).to have_http_status :created
      expect(json['data']['attributes']['name']).to eql 'cust name'
      # in db, too
      expect(Customer.find(json['data']['id']).identification).to eql 'X-1234'
      # location header
      expect(response.headers['Location']).to eql api_v1_customer_url json['data']['id']
    end
  end

  describe 'Customer updating' do
    it 'PUT /api/v1/customers/:id' do
      mod = {
        'data' => {
          'attributes' => {
            'name' => 'modified NAME'
          }
        }
      }
      put api_v1_customer_url(@customer), mod.to_json, @headers
      expect(response).to be_success
      #name modified
      expect(json['data']['attributes']['name']).to eql 'modified NAME'
      # the rest not
      expect(json['data']['attributes']['email']).to eql @customer.email
      # in db, too
      expect(Customer.find(json['data']['id']).name).to eql 'modified NAME'
    end
  end

  describe 'Customer deletion' do
    it 'DELETE /api/v1/customers/:id' do
      delete api_v1_customer_path(@customer), nil, @headers
      expect(response).to have_http_status :no_content
      expect(Customer.find_by_id(@customer.id)).to be_nil
    end
  end

end
