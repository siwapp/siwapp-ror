require 'rails_helper'

RSpec.describe "Api::V1::Series", type: :request do

  before do
    Rails.cache.clear
    FactoryBot.create :token
    FactoryBot.create :user
    @headers = {'Content-Type' => 'application/json',
        'Authorization' => 'Token token="123token"'}
    @series = FactoryBot.create :series
  end

  describe 'Series show' do
    it 'GET /api/v1/series/:id' do
      get api_v1_series_path(@series), headers: @headers
      expect(response).to be_successful
      expect(json['data']['attributes']['name']).to eql 'A- Series'
    end
  end

  describe 'Series listing' do
    it 'GET /api/v1/series' do
      get api_v1_series_index_path, headers: @headers
      expect(response).to be_successful
      expect(json.length).to eql 1
      expect(json['data'][0]['attributes']['name']).to eql 'A- Series'
    end
  end

  describe 'Series creation' do
    it 'POST /api/v1/series' do
      sr = {
        'data' => {
          'attributes' => {
            'name' => 'newSERIES',
            'value' => 33
          }

        }
      }
      post api_v1_series_index_path, params: sr.to_json, headers: @headers
      expect(response).to be_successful
      expect(json['data']['attributes']['name']).to eql 'newSERIES'
      # in db, too
      expect(Series.find(json['data']['id']).name).to eql 'newSERIES'
      # location header
      expect(response.headers['Location']).to eql api_v1_series_url(json['data']['id'])
    end
  end

  describe 'Series updating' do
    it 'PUT /api/v1/series/:id' do
      mod = {
        'data' => {
          'attributes' =>{
            'name' => 'modS',
            'default' => true
          }
        }
      }
      put api_v1_series_url(@series), params: mod.to_json, headers: @headers
      expect(response).to be_successful
      # name modified
      expect(json['data']['attributes']['name']).to eql 'modS'
      # in db, too
      expect(Series.find(json['data']['id']).name).to eql 'modS'
    end
  end

  describe 'Series deletion' do
    it 'DELETE /api/v1/series/:id' do
      delete api_v1_series_path(@series), headers: @headers
      expect(response).to have_http_status :no_content
      expect(Series.find_by_id(@series.id)).to be_nil
    end
  end

end
