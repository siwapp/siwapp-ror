require "rails_helper"

RSpec.describe "Customers", type: :request do

  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @invoice = FactoryBot.create(:invoice, :paid)
  end

  describe "Customers show" do
    it "GET /api/v1/customers/:id show customer with details" do
      get api_v1_customer_path(@invoice.customer), headers: @headers
      expect(response).to be_successful
      expect(json["data"]["type"]).to eql "customers"
      expect(json["data"]["attributes"]["name"]).to eql @invoice.customer.name
    end

    it "GET /api/v1/customers/:id/invoices shows filtered invoices" do
      # create extra invoice for another customer
      alt_customer = FactoryBot.create(:customer, name: "Alt Customer")
      alt_invoice = FactoryBot.create :invoice, customer: alt_customer
      print_template = FactoryBot.create :template, print_default: true, name: "print default", template: "invoice"
      get api_v1_customer_invoices_path(@invoice.customer), headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 1 # only @invoice, not alt_invoice
      expect(json["data"][0]["id"]).to eql @invoice.id.to_s
    end
  end

  describe "Custoners listing" do
    it "GET /api/v1/customers" do
      get api_v1_customers_path, headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 1
      expect(json["data"][0]["attributes"]["name"]).to eql @invoice.customer.name
    end
  end

  describe "Customer creation" do
    it "POST /api/v1/customers" do
      cust = {
        "data" => {
          "type" => "customers",
          "attributes" => {
            "name" => "cust name",
            "identification" => "X-1234",
            "email" => "test@example.com"
          }
        }
      }
      post api_v1_customers_url, params: cust.to_json, headers: @headers
      expect(response).to have_http_status :created
      expect(json["data"]["attributes"]["name"]).to eql "cust name"
      # in db, too
      expect(Customer.find(json["data"]["id"]).identification).to eql "X-1234"
      # location header
      expect(response.headers["Location"]).to eql api_v1_customer_url json["data"]["id"]
    end
  end

  describe "Customer updating" do
    it "PUT /api/v1/customers/:id" do
      mod = {
        "data" => {
          "attributes" => {
            "name" => "modified NAME"
          }
        }
      }
      put api_v1_customer_url(@invoice.customer), params: mod.to_json, headers: @headers
      expect(response).to be_successful
      #name modified
      expect(json["data"]["attributes"]["name"]).to eql "modified NAME"
      # the rest not
      expect(json["data"]["attributes"]["email"]).to eql @invoice.customer.email
      # in db, too
      expect(Customer.find(json["data"]["id"]).name).to eql "modified NAME"
    end
  end

  describe "Customer deletion" do
    it "DELETE /api/v1/customers/:id" do
      delete api_v1_customer_path(@invoice.customer), headers: @headers
      expect(response).to have_http_status :no_content
      expect(Customer.find_by_id(@invoice.customer.id)).to be_nil
    end
  end

end
