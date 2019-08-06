require "rails_helper"

RSpec.describe "Api::V1::Payments:", type: :request do
  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @invoice = FactoryBot.create(:invoice, :paid)
    @payment = @invoice.payments.first
  end

  describe "Payments show" do
    it "GET /api/v1/payments/:id show single payment with details" do
      get api_v1_payment_path(@payment), headers: @headers
      expect(response).to be_successful
      # invoice reference
     # expect(json["data"]["relationships"]["invoice"]["data"]["links"]["related"]).to eql api_v1_invoice_url(@invoice)
      expect(json["data"]["attributes"]["amount"]).to eql "10600.0"
    end
  end

  describe "Payments listing" do
    it "GET /api/v1/invoices/:invoice_id/payments" do
      get api_v1_invoice_payments_path(@invoice), headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 1
      # no invoice reference
      expect(json["data"][0]["relationships"]).to be_nil
    end
  end

  describe "Payment creation" do
    it "POST /api/v1/invoices/:invoice_id/payments" do
      invoice = FactoryBot.create(:invoice)

      payment = {
        "data"=> {
          "type" => "payments",
          "attributes" => {
            "notes" => "new notes",
            "date" => Date.current.strftime("%Y-%m-%d"),
            "amount" => invoice.unpaid_amount
          }
        }
      }

      post api_v1_invoice_payments_path(invoice), params: payment.to_json, headers: @headers

      expect(response).to have_http_status :created
      expect(json["data"]["attributes"]["notes"]).to eql "new notes"

      # db, too
      expect(Payment.find(json["data"]["id"]).amount).to eql 10600.0

      # location header
      expect(response.headers["Location"]).to eql api_v1_payment_url json["data"]["id"]
    end
  end

  describe "Payment updating" do
    it "PUT /api/v1/payments/:id" do
      mod = {
        "data" => {
          "attributes" => {
          "notes" => "modified NOTES"
          }
        }
      }
      put api_v1_payment_url(@payment), params: mod.to_json, headers: @headers
      expect(response).to be_successful
      # notes modified
      expect(json["data"]["attributes"]["notes"]).to eql "modified NOTES"
      # date not
      expect(json["data"]["attributes"]["date"]).to eql Date.current.strftime("%Y-%m-%d")
      # db, too
      expect(Payment.find(json["data"]["id"]).notes).to eql "modified NOTES"
    end
  end

  describe "payment deletion" do
    it "DELETE /api/v1/payments/:id" do
      delete api_v1_payment_path(@payment), headers: @headers
      expect(response).to have_http_status :no_content
      expect(Payment.find_by_id(@payment.id)).to be_nil
    end
  end

end
