require "rails_helper"

RSpec.describe "Invoices Search", type: :request do

  before do
    FactoryBot.create :token
    FactoryBot.create :user

    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }

    FactoryBot.create(:invoice)
    FactoryBot.create(:invoice,
        name: "Pete",
        issue_date: "2016-01-06",
        meta_attributes: '{"mykey":"myvalue"}')

    FactoryBot.create(:template)
  end

  describe "searches right with terms" do
    it "being 'test'" do
      query = {q: {with_terms: "test"}}
      get api_v1_invoices_path, params: query, headers: @headers
      expect(response).to have_http_status(:success)
      expect(response.body).to match '"Test Customer"'
      expect(response.body).not_to match '"Pete"'
    end

    it "being 'pete'" do
      query = {q: {with_terms: "pete"}}
      get api_v1_invoices_path, params: query, headers: @headers
      expect(response).to have_http_status(:success)
      expect(response.body).to match '"Pete"'
      expect(response.body).not_to match '"Test Customer"'
    end
  end

  describe "filters right by issue_date" do
    it "get all when filtering from long time ago" do
      query = {q: {issue_date_gteq: "2012-01-01", issue_date_lteq: ""}}
      get api_v1_invoices_path, params: query, headers: @headers
      expect(response.body).to match '"Pete"'
      expect(response.body).to match '"Test Customer"'
    end

    it "gets one when filtering" do
      query = {q: {issue_date_gteq: "2016-01-07", issue_date_lteq: ""}}
      get api_v1_invoices_path, params: query, headers: @headers
      expect(response.body).not_to match '"Pete"'
      expect(response.body).to match '"Test Customer"'
    end

    it "gets none when filtering both" do
      query = {q: {issue_date_gteq: "2016-01-07", issue_date_lteq: "2016-12-01"}}
      get api_v1_invoices_path, params: query, headers: @headers
      expect(response.body).not_to match '"Pete"'
      expect(response.body).not_to match '"Test Customer"'
    end
   end

   describe "searches right by meta_attributes wiht meta param" do
     it "gets the right one with key:value" do
      get api_v1_invoices_path, params: {meta: {mykey: "myvalue"}}, headers: @headers
      expect(response.body).to match '"Pete"'
      expect(response.body).not_to match '"Test Customer"'
     end
   end
end
