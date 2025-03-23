require 'spec_helper'

RSpec.describe Routes::API do
  let(:api_version) { Container[:config]['api']['version'] }
  
  describe 'GET /api/:v/stationboards/:region/:stop' do
    context 'with invalid API version' do
      it 'returns 404 error' do
        get '/api/v0/stationboards/ch/zurich'
        
        expect(last_response.status).to eq(404)
        json_response = JSON.parse(last_response.body)
        expect(json_response['error']).to eq('Not Found')
      end
    end
    
    context 'with invalid date format' do
      it 'returns 400 error' do
        get "/api/v#{api_version}/stationboards/ch/zurich?date=invalid-date"
        
        expect(last_response.status).to eq(400)
        json_response = JSON.parse(last_response.body)
        expect(json_response['error']).to eq('Bad Request')
      end
    end
    
    context 'with valid parameters' do
      before do
        # Mock the external API and formatter
        allow_any_instance_of(StationboardController).to receive(:get_formatter).and_return(double('formatter'))
        allow_any_instance_of(StationboardController).to receive(:get_external_api).and_return(double('api'))
        
        request_processor = double('request_processor')
        allow(request_processor).to receive(:process).and_return('test response')
        allow(Container['request_processor']).to receive(:call).and_return(request_processor)
        
        allow_any_instance_of(StationboardController).to receive(:get_response_type).and_return('application/json')
      end
      
      it 'returns stationboard data for departures' do
        get "/api/v#{api_version}/stationboards/ch/zurich"
        
        expect(last_response).to be_ok
        expect(last_response.body).to eq('test response')
      end
      
      it 'returns stationboard data for arrivals' do
        get "/api/v#{api_version}/stationboards/ch/zurich?mode=arrivals"
        
        expect(last_response).to be_ok
        expect(last_response.body).to eq('test response')
      end
      
      it 'returns stationboard data for specific date' do
        get "/api/v#{api_version}/stationboards/ch/zurich?date=01/01/2023"
        
        expect(last_response).to be_ok
        expect(last_response.body).to eq('test response')
      end
    end
  end
end 