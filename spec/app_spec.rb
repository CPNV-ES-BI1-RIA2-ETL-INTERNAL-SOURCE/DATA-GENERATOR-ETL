require 'spec_helper'

RSpec.describe App do
  describe 'GET /' do
    it 'returns ok status and version' do
      get '/'
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['status']).to eq('ok')
      expect(json_response).to have_key('version')
    end
  end

  describe 'GET /health' do
    it 'returns ok status and timestamp' do
      get '/health'
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['status']).to eq('ok')
      expect(json_response).to have_key('timestamp')
    end
  end

  describe 'GET /not-found' do
    it 'returns 404 status for non-existent routes' do
      get '/not-found'
      
      expect(last_response.status).to eq(404)
      json_response = JSON.parse(last_response.body)
      expect(json_response['error']).to eq('Not found')
      expect(json_response['status']).to eq(404)
    end
  end
end 