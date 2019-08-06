require "rails_helper"

RSpec.describe "Api::V1::Items:", type: :request do
  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    @invoice = FactoryBot.create(:invoice, :paid)
    @item = @invoice.items[0]
    @taxes = Tax.all
  end

  describe "Show:" do
    it "GET /api/v1/items/:id -- Single item with details" do
      get api_v1_item_path(@item), headers: @headers
      expect(response).to be_successful
    end
  end

  describe "List:" do
    it "GET /api/v1/invoices/:invoice_id/items -- A list of items" do
      get api_v1_invoice_items_path(@invoice.id), headers: @headers
      expect(response).to be_successful
      expect(json["data"].length).to eql 1 # 3 items
      expect(json["data"][0]["relationships"]["invoice"]).to be_nil
      expect(json["data"][0]["relationships"]["taxes"]["data"].length).to eql 2
    end
  end

  describe "Item creation" do
    before do
      @taxes = Tax.all
    end

    it "POST /api/v1/invoices/:invoice_id/items with taxes_id and taxes names" do
      item = {
        "data" => {
          "attributes" => {
            "description" => "brand new item",
            "quantity" => 2,
            "tax_ids" => [@taxes[0].id]
          }
        }
      }
      post api_v1_invoice_items_path(@invoice), params: item.to_json, headers: @headers
      expect(response).to have_http_status :created
      expect(json["data"]["attributes"]["tax-ids"][0]).to eql @taxes[0].id # tax assignment by id
      # expect(json["data"][1]["attributes"]["name"]).to eql "RETENTION" # tax assignment by name
      # db, too
      expect(Item.find(json["data"]["id"]).description).to eql "brand new item"
    end
  end

  describe "Item updating" do

    before do
      @taxes = Tax.all
    end

    it "PUT /api/v1/items/:id" do
      mod = {"data"=> {"attributes" => {"quantity"=>33, "tax_ids"=>[@taxes[1].id]}}}
      put api_v1_item_path(@item), params: mod.to_json, headers: @headers
      expect(response).to have_http_status :ok
      expect(json["data"]["attributes"]["quantity"]).to eql "33.0"
      expect(json["data"]["attributes"]["tax-ids"][0]).to eql @taxes[1].id
      item = Item.find @item.id
      # the db, too
      expect(item.taxes[0].id).to eql @taxes[1].id
    end
  end

  describe "Item deletion" do

    it "DELETE /api/v1/items/:id" do
      delete api_v1_item_path(@item), headers: @headers
      expect(response).to have_http_status :no_content
      expect(Item.find_by_id(@item.id)).to be_nil
    end
  end
end
