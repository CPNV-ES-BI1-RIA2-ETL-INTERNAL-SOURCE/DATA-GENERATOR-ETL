# frozen_string_literal: true

require 'sinatra/base'
require 'puma'
require 'date'
require_relative './services/request_processor'
require_relative './config'
require_relative 'container'

# Server class that handles the API requests
class Server < Sinatra::Base
  # Auto-inject dependencies from the container
  include Import[:logger, :config]

  get '/api/:v/stationboards/:region/:stop' do
    logger.info("#{request.env['REQUEST_METHOD']} #{request.env['REQUEST_URI']}")
    if params['v'][1..params['v'].length] != config['api']['version']
      halt 404,
           "Unsupported API Version: #{params['v']}"
    end
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

  # Use environment variable PORT as default, fallback to 8000 if not set
  def self.start_server!
    set :port, ENV['PORT'] ? ENV['PORT'].to_i : 8000
    set :bind, '0.0.0.0'
    set :environment, :production if ENV['APP_ENV'] == 'production'

    run!
  end

  private

  def construct_request_processor(country:, method:, mimetype: 'application/json')
    formatter = get_formatter(mimetype)
    external_api = get_external_api(country, method)
    
    # Pass logger as a named parameter to ensure it gets properly injected
    RequestProcessor.new(formatter, external_api)
  end

  def get_formatter(mimetype)
    formatter_class = config.formatters[mimetype]
    halt 415, "Unsupported Media Type: #{mimetype}" if formatter_class.nil?
    formatter_class.new
  end

  def get_external_api(country, method)
    region_apis = config.region_api[country]
    halt 404, 'No Data Found for this request' if region_apis.nil? || region_apis.empty?

    accepted_apis = region_apis.select { |api| valid_api?(api: api, method: method) }
    halt 404, 'No Data Found for this request' if accepted_apis.empty?

    accepted_apis.first.new
  end

  def valid_api?(api:, method:)
    method_name = method

    api.method_defined?(method_name)
  end

  def process_request(request_processor, options)
    request_processor.process({ stop: options[:stop], date: options[:date] })
  end
end
