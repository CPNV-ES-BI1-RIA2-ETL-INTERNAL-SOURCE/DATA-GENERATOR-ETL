# frozen_string_literal: true

require 'spec_helper'
require_relative '../../src/services/request_processor'

RSpec.describe RequestProcessor do
  let(:formatter) { double('formatter') }
  let(:external_api) { double('external_api') }
  let(:processor) { RequestProcessor.new(formatter, external_api) }

  describe '#process' do
    let(:request_data) do
      {
        stop: 'zurich',
        date: '2023-01-01',
        mode: 'departures'
      }
    end

    let(:api_response) do
      {
        'station' => 'Zurich HB',
        'departures' => [
          {
            'time' => '12:00',
            'destination' => 'Bern',
            'platform' => '7'
          }
        ]
      }
    end

    let(:formatted_response) { 'formatted response' }

    it 'processes the request and returns formatted data' do
      expect(external_api).to receive(:get_stationboard).with(request_data).and_return(api_response)
      expect(formatter).to receive(:format).with(api_response).and_return(formatted_response)

      result = processor.process(request_data, 'get_stationboard')

      expect(result).to eq(formatted_response)
    end

    it 'handles different API methods' do
      expect(external_api).to receive(:post_stationboard).with(request_data).and_return(api_response)
      expect(formatter).to receive(:format).with(api_response).and_return(formatted_response)

      result = processor.process(request_data, 'post_stationboard')

      expect(result).to eq(formatted_response)
    end

    it 'raises an error when the API method does not exist' do
      allow(external_api).to receive(:respond_to?).with('invalid_method').and_return(false)
      allow(external_api).to receive(:invalid_method).and_raise(NoMethodError)

      expect { processor.process(request_data, 'invalid_method') }.to raise_error(NoMethodError)
    end
  end
end
