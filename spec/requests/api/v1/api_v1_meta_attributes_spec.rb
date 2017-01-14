require "rails_helper"

RSpec.describe "Api::V1::Payments:", type: :request do

  before do
    FactoryGirl.create :token
    FactoryGirl.create :user

    @invoice = FactoryGirl.create :invoice, meta_attributes: '{"pepito": "grillo", "tarzan": "chita"}'
    @headers = {
      'Content-Type' => 'application/json',
      "Authorization" => "Token token=\"#{Settings.api_token}\""
    }
  end

  describe "Meta Attributes listing" do
    it 'GET /api/v1/invoices/:invoice_id/meta_attributes show meta attrs from invoice' do
      get api_v1_invoice_meta_attributes_path(@invoice), nil, @headers
      expect(response).to be_success
      expect(json['data']).to eql({'pepito' => 'grillo', 'tarzan' => 'chita'})
    end
  end

  describe "Create Meta Attribute" do
    it 'PUT /api/v1/invoices/:invoice_id/meta_attributes/pipo creates new meta attr' do
      meta_attr = {
        'data'=> {
          'attributes' => {'value' => 'perez' }
        }
      }
      put api_v1_invoice_meta_attribute_path(@invoice, 'pipo'), meta_attr.to_json, @headers
      expect(response).to be_success
      expect(json['data']).to eql({'pipo' => 'perez'})
      expect(Invoice.find(@invoice.id).get_meta('pipo')).to eql 'perez' # saved at db
    end
  end

  describe "Update Meta Attribute" do
    it 'PUT /api/v1/invoices/:invoice_id/meta_attributes/pepito updates meta attr' do
      meta_attr = {
        'data'=> {
          'attributes' => {'value' => 'el salvaje' }
        }
      }
      put api_v1_invoice_meta_attribute_path(@invoice, 'pepito'), meta_attr.to_json, @headers
      expect(response).to be_success
      expect(json['data']).to eql({'pepito' => 'el salvaje'})
      expect(Invoice.find(@invoice.id).get_meta('pepito')).to eql 'el salvaje' # updated at db
    end
  end

  describe "Remove Meta Attribute" do
    it 'DELETE /api/v1/invoices/:invoice_id/meta_attributes/pepito deletes meta attr' do
      delete api_v1_invoice_meta_attribute_path(@invoice, 'pepito'), nil, @headers
      expect(response).to have_http_status(:no_content)
      expect(Invoice.find(@invoice.id).get_meta('pepito')).to be_nil
    end
  end

end
