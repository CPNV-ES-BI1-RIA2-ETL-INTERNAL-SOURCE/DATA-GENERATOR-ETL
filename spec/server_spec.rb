# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../src/server'

RSpec.describe Server, type: :request do
  include Rack::Test::Methods

  let(:station) { 'lausanne' }
  let(:region) { 'switzerland' }
  let(:date) { '2024-12-15' }
  let(:valid_mimetype) { 'application/json' }
  let(:invalid_mimetype) { 'application/xml' }

  def app
    Server
  end

  describe 'GET /api/stationboard/:region/:station' do
    context 'given a valid region and station' do
      it 'returns a 200 status and data in JSON format' do
        get "/api/v1/stationboard/#{region}/#{station}", {}, 'HTTP_ACCEPT' => valid_mimetype

        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include(valid_mimetype)
      end

      it 'returns a 415 status when the mimetype is unsupported' do
        get "/api/v1/stationboard/#{region}/#{station}", {}, 'HTTP_ACCEPT' => invalid_mimetype

        expect(last_response.status).to eq(415)
      end

      it 'returns a 404 status when the station or region is invalid' do
        get "/api/v1/stationboard/invalid_region/invalid_station", {}, 'HTTP_ACCEPT' => valid_mimetype

        expect(last_response.status).to eq(404)
      end
    end

    context 'given a valid region, station, and date' do
      it 'returns a 200 status and data in JSON format' do
        get "/api/v1/stationboard/#{region}/#{station}?date=#{date}", {}, 'HTTP_ACCEPT' => valid_mimetype

        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include(valid_mimetype)
      end
    end

    context 'given an invalid region, station, or date' do
      it 'returns a 404 status' do
        get "/api/v1/stationboard/invalid_region/invalid_station?date=#{date}", {}, 'HTTP_ACCEPT' => valid_mimetype

        expect(last_response.status).to eq(404)
      end
    end
  end
end
