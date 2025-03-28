# frozen_string_literal: true

require 'spec_helper'
require_relative '../../src/externalAPIs/api_exceptions'

RSpec.describe StationboardController do
  # Create a test class that includes the controller module
  let(:controller_class) do
    Class.new do
      include StationboardController

      # Mock the Sinatra halt method
      def halt(status, body)
        @halted = true
        @halt_status = status
        @halt_body = body
        raise "Halted with status #{status}"
      end

      def halted?
        @halted
      end

      attr_reader :halt_status

      attr_reader :halt_body
    end
  end

  let(:controller) { controller_class.new }

  describe '#get_stationboard' do
    let(:formatter) { double('formatter') }
    let(:external_api) { double('external_api') }
    let(:request_processor) { double('request_processor') }
    let(:options) do
      {
        mimetype: 'application/json',
        region: 'ch',
        stop: 'zurich',
        date: '2023-01-01',
        mode: 'departures',
        method: 'get_stationboard'
      }
    end

    before do
      allow(controller).to receive(:get_formatter).and_return(formatter)
      allow(controller).to receive(:get_external_api).and_return(external_api)
      allow(Container['request_processor']).to receive(:call).and_return(request_processor)
      allow(request_processor).to receive(:process).and_return('test response')
      allow(controller).to receive(:get_response_type).and_return('application/json')
    end

    it 'returns formatted stationboard data with content type' do
      result = controller.get_stationboard(options)

      expect(result[:content]).to eq('test response')
      expect(result[:content_type]).to eq('application/json')
    end

    it 'processes the request with correct parameters' do
      expect(request_processor).to receive(:process).with(
        {
          stop: 'zurich',
          date: '2023-01-01',
          mode: 'departures'
        },
        'get_stationboard'
      )

      controller.get_stationboard(options)
    end
  end

  describe '#get_formatter' do
    let(:config) { double('config') }
    let(:formatter_class) { double('formatter_class') }
    let(:formatters) { { 'application/json' => { class: formatter_class } } }

    before do
      allow(Container).to receive(:[]).with(:config).and_return(config)
      allow(config).to receive(:formatters).and_return(formatters)
      allow(formatter_class).to receive(:new).and_return(double('formatter'))
    end

    it 'returns the correct formatter for the given mimetype' do
      expect(formatter_class).to receive(:new)
      expect { controller.send(:get_formatter, 'application/json') }.not_to raise_error
    end

    it 'raises an InvalidRequestError for unsupported mimetypes' do
      # We need to avoid the nil error by returning an empty hash
      allow(formatters).to receive(:[]).with('application/unsupported').and_return({})
      # Ensure the class key is nil
      allow(formatters['application/unsupported']).to receive(:[]).with(:class).and_return(nil)

      expect { controller.send(:get_formatter, 'application/unsupported') }
        .to raise_error(ApiExceptions::InvalidRequestError)
    end
  end

  describe '#get_response_type' do
    let(:config) { double('config') }
    let(:formatters) do
      {
        'application/json' => {
          response: { 'type' => 'application/json' }
        }
      }
    end

    before do
      allow(Container).to receive(:[]).with(:config).and_return(config)
      allow(config).to receive(:formatters).and_return(formatters)
    end

    it 'returns the correct content type for the given mimetype' do
      result = controller.send(:get_response_type, 'application/json')
      expect(result).to eq('application/json')
    end

    it 'raises an InvalidRequestError for unsupported mimetypes' do
      # We need to avoid the nil error by returning an empty hash
      allow(formatters).to receive(:[]).with('application/unsupported').and_return({})
      # Ensure the response key exists but type is nil
      allow(formatters['application/unsupported']).to receive(:[]).with(:response).and_return({})
      allow(formatters['application/unsupported'][:response]).to receive(:[]).with('type').and_return(nil)

      expect { controller.send(:get_response_type, 'application/unsupported') }
        .to raise_error(ApiExceptions::InvalidRequestError)
    end
  end

  describe '#get_external_api' do
    let(:config) { double('config') }
    let(:api_class) { Class.new }

    before do
      allow(Container).to receive(:[]).with(:config).and_return(config)
      allow(config).to receive(:region_api).and_return({
                                                         'ch' => [api_class],
                                                         'de' => []
                                                       })
      allow(api_class).to receive(:method_defined?).and_return(true)
      allow(api_class).to receive(:new).and_return(double('api'))
    end

    it 'returns the correct API for the given region and method' do
      expect(api_class).to receive(:new)
      expect { controller.send(:get_external_api, 'ch', 'get_stationboard') }.not_to raise_error
    end

    it 'raises a ResourceNotFoundError for empty region APIs' do
      expect { controller.send(:get_external_api, 'de', 'get_stationboard') }
        .to raise_error(ApiExceptions::ResourceNotFoundError)
    end

    it 'raises a ResourceNotFoundError for unsupported regions' do
      expect { controller.send(:get_external_api, 'fr', 'get_stationboard') }
        .to raise_error(ApiExceptions::ResourceNotFoundError)
    end
  end

  describe '#valid_api?' do
    let(:api_class) { Class.new }

    it 'returns true if the API has the requested method' do
      allow(api_class).to receive(:method_defined?).with('get_stationboard').and_return(true)

      result = controller.send(:valid_api?, api: api_class, method: 'get_stationboard')
      expect(result).to be true
    end

    it 'returns false if the API does not have the requested method' do
      allow(api_class).to receive(:method_defined?).with('invalid_method').and_return(false)

      result = controller.send(:valid_api?, api: api_class, method: 'invalid_method')
      expect(result).to be false
    end
  end
end
