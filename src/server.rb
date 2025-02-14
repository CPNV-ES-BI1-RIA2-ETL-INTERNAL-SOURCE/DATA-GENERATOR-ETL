# frozen_string_literal: true

require 'sinatra/base'
require 'puma'
require 'date'
require_relative './services/request_processor'
require_relative './config'
require_relative 'app'

# Server class that handles the API requests
class Server < Sinatra::Base
  get '/api/:v/stationboards/:region/:stop' do
    App.instance[:logger].info("#{request.env['REQUEST_METHOD']} #{request.env['REQUEST_URI']}")
    halt 404, "Unsupported API Version: #{params['v']}" if params['v'][1..params['v'].length] != App.instance[:config]['api']['version']
    mimetype = request.env['HTTP_ACCEPT']
    stop = params['stop']

    if params['date']
      halt 400, 'Invalid Date Format' unless params['date'].match?(%r{^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{4}$})
      date = params['date']
    else
      date = Date.today.to_s
    end

    region = params['region']
    mode = params['mode'] || 'departures'

    external_api_method = "#{request.env['REQUEST_METHOD'].downcase}_stationboard"

    request_processor = construct_request_processor(mimetype: mimetype, country: region, method: external_api_method)

    data = request_processor.process({ stop: stop, date: date, mode: mode }, external_api_method)
    status 200
    content_type mimetype
    data
  end

  not_found do
    status 404
    body 'Not found'
  end

  # TODO NGY - port number hard coded... need to be changed.
  def self.start_server!(port: 8080)
    set :port, port
    set :bind, '0.0.0.0'
    set :environment, :production

    run!
  end

  private

  def construct_request_processor(country:, method:, mimetype: 'application/json')
    formatter_class = App.instance[:config].formatters[mimetype]

    halt 415, "Unsupported Media Type: #{mimetype}" if formatter_class.nil?

    formatter = formatter_class.new

    region_apis = App.instance[:config].region_api[country]
    halt 404, 'No Data Found for this request' if region_apis.nil? || region_apis.empty?

    accepted_apis = []
    region_apis.each do |api|
      accepted_apis << api if valid_api?(api: api, method: method)
    end

    halt 404, 'No Data Found for this request' if accepted_apis.empty?

    external_api = accepted_apis.first.new

    RequestProcessor.new(formatter, external_api)
  end

  def valid_api?(api:, method:)
    method_name = method

    api.method_defined?(method_name)
  end

  def process_request(request_processor, options)
    request_processor.process({stop: options[:stop], date: options[:date]})
  end
end
