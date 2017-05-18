require "rails_helper"

RSpec.describe "Search Invoices", type: :request do

  before do
    Rails.application.load_seed

    FactoryGirl.create(:user)
    FactoryGirl.create(:invoice)
    FactoryGirl.create(:invoice,
        name: "Pete",
        issue_date: "2016-01-06",
        meta_attributes: '{"mykey":"myvalue"}')

    post "/login", :session =>
        {email: "testuser@example.org", password: "testuser"}
  end

  describe "searches right with terms" do
    it "being 'test'" do
      get invoices_path, q: {with_terms: "test"}
      expect(response).to have_http_status(:success)
      expect(response.body).to match "<td .*Test Customer"
      expect(response.body).not_to match "<td .*Pete"
    end

    it "being 'pete'" do
      get invoices_path, q: {with_terms: "pete"}
      expect(response).to have_http_status(:success)
      expect(response.body).to match "<td .*Pete"
      expect(response.body).not_to match "<td .*Test Customer"
    end
  end

  describe "filters right by issue_date" do
    it "get all when filtering from long time ago" do
      q = {issue_date_gteq: "2012-01-01", issue_date_lteq: ""}
      get invoices_path, q: q
      expect(response.body).to match "<td .*Pete"
      expect(response.body).to match "<td .*Test Customer"
    end

    it "gets one when filtering" do
      q = {issue_date_gteq: "2016-01-07", issue_date_lteq: ""}
      get invoices_path, q: q
      expect(response.body).not_to match "<td .*Pete"
      expect(response.body).to match "<td .*Test Customer"
    end

    it "gets none when filtering both" do
      q = {issue_date_gteq: "2016-01-07", issue_date_lteq: "2016-12-01"}
      get invoices_path, q: q
      expect(response.body).not_to match "<td .*Pete"
      expect(response.body).not_to match "<td .*Test Customer"
    end
   end

   describe "searches right by meta_attributes wiht meta param" do
     it "gets the right one with just the key" do
      get invoices_path, meta: "mykey"
      expect(response.body).to match "<td .*Pete"
      expect(response.body).not_to match "<td .*Test Customer"
     end

     it "gets the right one with key:value" do
      get invoices_path, meta: "mykey:myvalue"
      expect(response.body).to match "<td .*Pete"
      expect(response.body).not_to match "<td .*Test Customer"
     end
   end
end
