require 'rails_helper'

RSpec.describe "Api::V1::Payments", type: :request do

  before do
    Rails.cache.clear
    FactoryGirl.create :token
    FactoryGirl.create :user
    @headers = {'Content-Type' => 'application/json', 
        'Authorization' => 'Token token="123token"'}
    @customer = FactoryGirl.create :customer
    @series = FactoryGirl.create :series
    @invoice = FactoryGirl.create :invoice, customer: @customer
    @payment = @invoice.payments.first

  end

  describe "Payments show" do
    it 'GET /api/v1/payments/:id show single payment with details' do
      get api_v1_payment_path(@payment), nil, @headers
      expect(response).to be_success
      # invoice reference
      expect(json['invoice']['url']).to eql api_v1_invoice_url(@invoice)
      expect(json['amount']).to eql '100.0'
    end
  end

  describe "Payments listing" do
    it 'GET /api/v1/invoices/:invoice_id/payments' do
      get api_v1_invoice_payments_path(@invoice), nil, @headers
      expect(response).to be_success
      expect(json.length).to eql 2
      # no invoice reference
      expect(json[0]['invoice']).to be_nil
    end
  end

  describe "Payment creation" do
    it 'POST /api/v1/invoices/:invoice_id/payments' do
      payment = {
        'payment'=> {
          'notes' => 'new notes',
          'date' => Date.current.strftime('%Y-%m-%d'),
          'amount' => 33.3
          }
      }
      post api_v1_invoice_payments_path(@invoice), payment.to_json, @headers
      expect(response).to have_http_status :created
      expect(json['notes']).to eql 'new notes'
      # db, too
      expect(Payment.find(json['id']).amount).to eql 33.3
      # location header
      expect(response.headers['Location']).to eql api_v1_payment_url json['id']
    end
  end

  describe 'Payment updating' do
    it 'PUT /api/v1/payments/:id' do
      mod = {
        'payment' => {
          'notes' => 'modified NOTES'
        }
      }
      put api_v1_payment_url(@payment), mod.to_json, @headers
      expect(response).to be_success
      # notes modified
      expect(json['notes']).to eql 'modified NOTES'
      # date not
      expect(json['date']).to eql Date.current.strftime('%Y-%m-%d')
      # db, too
      expect(Payment.find(json['id']).notes).to eql 'modified NOTES'
    end
  end

  describe 'payment deletion' do
    it 'DELETE /api/v1/payments/:id' do
      delete api_v1_payment_path(@payment), nil, @headers
      expect(response).to have_http_status :no_content
      expect(Payment.find_by_id(@payment.id)).to be_nil
    end
  end

end
