require "rails_helper"

RSpec.describe "Api::V1::Invoices:", type: :request do

  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @template = FactoryBot.create(:template)
    @invoice = FactoryBot.create(:invoice)
    @vat = Tax.find(1)
  end

  describe "Show:" do
    it "GET /api/v1/invoices/:id -- Single invoice with details" do
      get api_v1_invoice_path(@invoice), headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 5

      expect(json["data"]["links"]["self"]).to eql api_v1_invoice_path(@invoice)
      expect(json["data"]["links"]["customer"]).to eql api_v1_customer_path(@invoice.customer)
      # download link
      expect(json["data"]["attributes"]["download-link"]).to eql api_v1_rendered_template_path(@template, @invoice)
    end
  end

  describe "Invoices Listing" do
    it "GET /api/v1/invoices Standard listing works ok" do

      get api_v1_invoices_path, headers: @headers

      expect(response).to be_successful
      expect(json["data"].is_a? Array).to be true
      expect(json["data"][0]["attributes"]["name"]).to eql "Test Customer"
    end

    describe "Paginated invoices listing" do

      before do
        FactoryBot.create_list :invoice, 30, customer: @invoice.customer # 30 more invoices
      end

      it "Display only 20 results per page and return pagination headers" do
        get api_v1_invoices_path, headers: @headers
        expect(response).to be_successful
        expect(json["data"].count).to eql 20
        expect(response.headers).to have_key "X-Pagination"
        pagination_header = JSON.parse response.headers["X-Pagination"]
        expect(pagination_header["total"]).to eql 31
        expect(pagination_header["next_page"]).to eql 2
      end

      it "A param sets the page" do
        get api_v1_invoices_path, params: {page: {number: 2}}, headers: @headers
        expect(response).to be_successful
        expect(json["data"].count).to eql 11
      end
    end
  end

  describe "Invoice creation" do

    it "basic invoice creation on POST request" do
      inv = {
        "data" => {
          "attributes" => {
            "name" => "newly created",
            "email" => "test@email.com",
            "issue_date" => "2016-06-06",
            "series_id" => @invoice.series.id,
            "currency" => "eur"
          },
          "meta" => {
            "m1" => "mv1"
          }
        }
      }
      post api_v1_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 201 # created resource
      expect(json["data"]["attributes"]["name"]).to eql "newly created"
      expect(json['data']['meta']['m1']).to eql 'mv1'
      expect(json["data"]["attributes"]["currency"]).to eql "eur"
      i = Invoice.find(json['data']['id'])
      expect(i.name).to eql "newly created"
      expect(i.get_meta 'm1').to eql 'mv1'
    end

    it "can create invoice along with items and payments" do
      inv = {
        "data" => {
          "attributes" => {
            "name" => "newly created",
            "email" => "test@email.com",
            "issue_date" => "2016-06-06",
            "series_id" => @invoice.series.id
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
                }]},
            "payments" => {
              "data" => [{
                "attributes" => {
                  "notes" => "payment 1",
                  "amount" => 3.3,
                  "date" => "2016-02-02"
                }
              }]
            }
          }
        }
      }

      post api_v1_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 201
      invoice = Invoice.find(json["data"]["id"])
      item = invoice.items[0]
      expect(item.description).to eql "item 1"
      expect(item.taxes.length).to eql 1
      expect(item.taxes[0].name).to eql "VAT"
      payment = invoice.payments[0]
      expect(payment.notes).to eql "payment 1"
      expect(payment.amount).to eql 3.3

    end

    it "proper invalidation messages" do
      inv = {
        "data" => {
          "attributes" => {
            "issue_date" => "2015-05-05",
            "email" => "test@bemail.com"
          }

        }
      }
      post api_v1_invoices_path, params: inv.to_json, headers: @headers
      expect(response.status).to eql 422 # unprocessable entity
    end

  end

  describe "Invoice updating" do

    it "basic invoice updating" do
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
      put api_v1_invoice_path(@invoice), params: uhash.to_json, headers: @headers
      expect(response.status).to eql 200
      expect(json["data"]["attributes"]["name"]).to eql "modified"
      expect(Invoice.find(@invoice.id).get_meta('m1')).to eql 'mvvv1'
    end

  end

  describe "Invoice deleting" do

    it "basic invoice deleting" do
      delete api_v1_invoice_path(@invoice), headers: @headers
      expect(response.status).to eql 204 # deleted resoource
      expect(Invoice.find_by_id(@invoice.id)).to be_nil
    end
  end

end
