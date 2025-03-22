# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../src/server'

RSpec.describe Server, type: :request do
  include Rack::Test::Methods

  let(:station) { 'lausanne' }
  let(:region) { 'CH' }
  let(:date) { '2024-12-15' }
  let(:valid_mimetype) { 'application/json' }
  let(:invalid_mimetype) { 'application/xml' }

  def app
    Server
  end
end

RSpec.describe Server, 'API responses with valid inputs', type: :request do
  include Rack::Test::Methods
  
  let(:station) { 'lausanne' }
  let(:region) { 'CH' }
  let(:date) { '2024-12-15' }
  let(:valid_mimetype) { 'application/json' }
  
  def app
    Server
  end
  
  it 'returns a 200 status and data in JSON format' do
    get "/api/v1/stationboards/#{region}/#{station}", {}, 'HTTP_ACCEPT' => valid_mimetype

    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to include(valid_mimetype)
  end
  
  it 'returns a 200 status when including a valid date parameter' do
    get "/api/v1/stationboards/#{region}/#{station}?date=#{date}", {}, 'HTTP_ACCEPT' => valid_mimetype

    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to include(valid_mimetype)
  end
end

RSpec.describe Server, 'API responses with invalid inputs', type: :request do
  include Rack::Test::Methods
  
  let(:station) { 'lausanne' }
  let(:region) { 'CH' }
  let(:date) { '2024-12-15' }
  let(:valid_mimetype) { 'application/json' }
  let(:invalid_mimetype) { 'application/xml' }
  
  def app
    Server
  end
  
  it 'returns a 415 status when the mimetype is unsupported' do
    get "/api/v1/stationboards/#{region}/#{station}", {}, 'HTTP_ACCEPT' => invalid_mimetype

    expect(last_response.status).to eq(415)
  end

  it 'returns a 404 status when the station or region is invalid' do
    get '/api/v1/stationboards/invalid_region/invalid_station', {}, 'HTTP_ACCEPT' => valid_mimetype

    expect(last_response.status).to eq(404)
  end
  
  it 'returns a 404 status when the region, station, and date are invalid' do
    get "/api/v1/stationboards/invalid_region/invalid_station?date=#{date}", {}, 'HTTP_ACCEPT' => valid_mimetype

    expect(last_response.status).to eq(404)
  end
end
