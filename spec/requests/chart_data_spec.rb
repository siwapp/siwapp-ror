require "rails_helper"

RSpec.describe "Get chart data", type: :request do

  before do
    FactoryGirl.create(:user)
    FactoryGirl.create_list(:invoice, 10)

    post "/login", :session =>
        {email: "testuser@example.org", password: "testuser"}
  end

  describe "searches right with terms" do
    it "being 'test'" do
      get chart_data_invoices_path, format: :json
      expect(response).to have_http_status(:success)
    end
  end

end
