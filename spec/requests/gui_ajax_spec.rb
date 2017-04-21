require 'rails_helper'
RSpec.describe "GuiAjaxSpec", type: :request do
  describe "Chart data" do
    it 'GET /invoices/chart_data.json gets data' do
      get invoices_chart_data, nil, {"content-type": "application/json"}
      expect(response).to be_success
    end
  end
end