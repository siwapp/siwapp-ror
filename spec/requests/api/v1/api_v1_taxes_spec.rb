require "rails_helper"

RSpec.describe "Api::V1::Taxes:", type: :request do
  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @vat = FactoryBot.create :vat
    @retention = FactoryBot.create :retention
  end

  describe "Taxes show" do
    it "GET /api/v1/taxes/:id" do
      get api_v1_tax_path(@vat), headers: @headers
      expect(response).to be_successful
      expect(json["data"]["attributes"]["name"]).to eql "VAT"
    end
  end

  describe "Taxes listing" do
    it "GET /api/v1/taxes" do
      get api_v1_taxes_path, headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 2
    end
  end

  describe "Taxes creation" do
    it "POST /api/v1/taxes" do
      tx = {
        "data" => {
          "attributes" => {
            "name" => "newTAX",
            "value" => 33
          }
        }
      }
      post api_v1_taxes_path, params: tx.to_json, headers: @headers
      expect(response).to be_successful
      expect(json["data"]["attributes"]["name"]).to eql "newTAX"
      # in db, too
      expect(Tax.find(json["data"]["id"]).name).to eql "newTAX"
      # location header
      expect(response.headers["Location"]).to eql api_v1_tax_url(json["data"]["id"])
    end
  end

  describe "Tax updating" do
    it "PUT /api/v1/taxes/:id" do
      mod = {
        "data" => {
          "attributes" => {
            "name" => "modTAX",
            "default" => true
          }
        }
      }
      put api_v1_tax_url(@vat), params: mod.to_json, headers: @headers
      expect(response).to be_successful
      # name modified
      expect(json["data"]["attributes"]["name"]).to eql "modTAX"
      # in db, too
      expect(Tax.find(json["data"]["id"]).name).to eql "modTAX"
    end
  end

  describe "Tax deletion" do
    it "DELETE /api/v1/taxes/:id" do
      delete api_v1_tax_path(@vat), headers: @headers
      expect(response).to have_http_status :no_content
      expect(Tax.find_by_id(@vat.id)).to be_nil
    end
  end

end
