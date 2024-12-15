# frozen_string_literal: true

require 'rspec'
require_relative '../../src/services/request_processor'

RSpec.describe RequestProcessor do
  let(:formatter) { double('Formatter') }
  let(:external_api) { double('ExternalApi') }
  let(:request_processor) { RequestProcessor.new(formatter, external_api) }
  let(:options) { { station: 'lausanne', date: '2024-12-15' } }
  let(:method) { 'get_stationboard' }
  let(:data) { { some: 'data' } }
  let(:formatted_data) { { formatted: 'data' } }

  describe '#process' do
    it 'sends the method to the external API with options and formats the data' do
      expect(external_api).to receive(:send).with(method, options).and_return(data)
      expect(formatter).to receive(:format).with(data).and_return(formatted_data)

      result = request_processor.process(options, method)

      expect(result).to eq(formatted_data)
    end
  end
end
