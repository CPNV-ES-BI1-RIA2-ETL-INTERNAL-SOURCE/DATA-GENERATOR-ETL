# frozen_string_literal: true

require 'rspec'
require 'httparty'
require_relative '../../src/externalAPIs/search_ch'
require_relative 'mock_search_api'

describe SearchAPI do
  let(:options) { { 'show_tracks' => 1, 'show_subsequent_stops' => 1 } }
  let(:api_client) { MockSearchAPI.new(options) }

  describe '#initialize' do
    it 'sets default options correctly' do
      expect(api_client.instance_variable_get(:@options)).to include(
                                                               query: hash_including(
                                                                 show_tracks: 1,
                                                                 show_subsequent_stops: 1,
                                                                 time: '00:01'
                                                               )
                                                             )
    end
  end

  describe '#stationboard' do
    # TODO missing context description
    context 'when fetching station timetable information' do
      let(:station) { 'Yverdon-les-Bains' }
      let(:date) { '12/12/2024' }
      let(:response) { double('HTTParty::Response') }

      before do
        allow(SearchAPI).to receive(:get).and_return(response)
      end

      it 'merges station and date into query parameters' do
        api_client.get_stationboard(station, date)
        options = api_client.instance_variable_get(:@options)
        pp options
        expect(options[:query]).to include(stop: station, date: date)
      end

      it 'calls the API with correct endpoint and options' do
        expect(SearchAPI).to receive(:get).with('/timetable/api/stationboard.json', hash_including(query: hash_including(stop: station, date: date)))
        api_client.get_stationboard(station, date)
      end

      it 'returns the API response' do
        expect(api_client.get_stationboard(station, date)).to eq(response)
      end
    end
  end

  describe '#get_connections' do
    it 'raises NotImplementedError' do
      expect { api_client.get_connections('Yverdon', 'Lausanne', '12/12/2024') }.to raise_error(NotImplementedError, 'Method not implemented')
    end
  end
end
