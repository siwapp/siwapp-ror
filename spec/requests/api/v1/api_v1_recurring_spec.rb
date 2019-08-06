require "rails_helper"

RSpec.describe "Api::V1::RecurringInvoices:", type: :request do

  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @recurring = FactoryBot.create(:recurring_invoice)
    @vat = Tax.find(1)
  end

  describe "Show:" do
    it "GET /api/v1/recurring_invoices/:id -- Single recurring with details" do
      get api_v1_recurring_invoice_path(@recurring), headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 5

      expect(json["data"]["links"]["self"]).to eql \
        api_v1_recurring_invoice_path(@recurring)
      expect(json["data"]["links"]["customer"]).to eql \
        api_v1_customer_path(@recurring.customer)
    end
  end

  describe "Recurring Invoices Listing" do
    it "GET /api/v1/recurring_invoices Standard listing works ok" do
      get api_v1_recurring_invoices_path, headers: @headers

      expect(response).to be_successful
      expect(json["data"].is_a? Array).to be true
      expect(json["data"][0]["attributes"]["name"]).to eql "Test Customer"
    end

    describe "Paginated invoices listing" do

      before do
        FactoryBot.create_list :recurring_invoice, 30,
          customer: @recurring.customer # 30 more invoices
      end

      it "Display only 20 results per page and return pagination headers" do
        get api_v1_recurring_invoices_path, headers: @headers
        expect(response).to be_successful
        expect(json["data"].count).to eql 20
        expect(response.headers).to have_key "X-Pagination"
        pagination_header = JSON.parse response.headers["X-Pagination"]
        expect(pagination_header["total"]).to eql 31
        expect(pagination_header["next_page"]).to eql 2
      end

      it "A param sets the page" do
        get api_v1_recurring_invoices_path, params: {page: {number: 2}}, headers: @headers
        expect(response).to be_successful
        expect(json["data"].count).to eql 11
      end
    end
  end

  describe "Recurring Invoice creation" do

    it "basic invoice creation on POST request" do
      inv = {
        "data" => {
          "attributes" => {
            "name" => "newly created",
            "email" => "test@email.com",
            "starting_date" => "2016-06-06",
            "days_to_due" => "30",
            "period" => "1",
            "period_type" => "monthly",
            "series_id" => @recurring.series.id,
            "currency" => "eur"
          },
          "meta" => {
            "m1" => "mv1"
          }
        }
      }
      post api_v1_recurring_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 201 # created resource
      expect(json["data"]["attributes"]["name"]).to eql "newly created"
      expect(json['data']['meta']['m1']).to eql 'mv1'
      expect(json["data"]["attributes"]["currency"]).to eql "eur"
      i = RecurringInvoice.find(json['data']['id'])
      expect(i.name).to eql "newly created"
      expect(i.get_meta 'm1').to eql 'mv1'
    end

    it "can create recurring invoice along with items and payments" do
      inv = {
        "data" => {
          "attributes" => {
            "name" => "newly created",
            "email" => "test@email.com",
            "starting_date" => "2016-06-06",
            "days_to_due" => "30",
            "period" => "1",
            "period_type" => "monthly",
            "series_id" => @recurring.series.id,
            "currency" => "eur"
          },
          "relationships" => {
            "items" => {
              "data" => [
                {"attributes" => {
                  "description" => "item 1",
                  "unitary_cost"=> 3.3,
                  "quantity" => 2,
                  "tax_ids" => [@vat.id]
                  }
                }
              ]
            }
          }
        }
      }

      post api_v1_recurring_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 201
      invoice = RecurringInvoice.find(json["data"]["id"])
      item = invoice.items[0]
      expect(item.description).to eql "item 1"
      expect(item.taxes[0].name).to eql "VAT"
    end

    it "proper invalidation messages" do
      inv = {
        "data" => {
          "attributes" => {
            "name" => "bogus",
            "period" => "1",
            "email" => "test@bemail.com"
          }

        }
      }
      post api_v1_recurring_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 422 # unprocessable entity
    end

  end

  describe "Recurring Invoice updating" do
    it "basic recurring invoice updating" do
      uhash = {
        'data': {
          'attributes': {
            'name': 'modified'
          },
          'meta': {
            'm1': 'mvvv1'
          }
        }
      }
      put api_v1_recurring_invoice_path(@recurring), params: uhash.to_json, headers: @headers
      expect(response.status).to eql 200
      expect(json["data"]["attributes"]["name"]).to eql "modified"
      expect(RecurringInvoice.find(@recurring.id).get_meta('m1')).to eql 'mvvv1'
    end
  end

  describe "Recurring Invoice deleting" do
    it "basic recurring invoice deleting" do
      delete api_v1_recurring_invoice_path(@recurring), headers: @headers
      expect(response.status).to eql 204 # deleted resoource
      expect(RecurringInvoice.find_by_id(@recurring.id)).to be_nil
    end
  end

  describe "Generate invoices endpoint" do
    it "generates correctly the invoice" do
      get api_v1_recurring_invoices_path + "/generate_invoices", headers: @headers
      expect(Invoice.belonging_to(@recurring.id).length).to eql 1
    end
  end

end
