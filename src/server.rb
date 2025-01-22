# frozen_string_literal: true

require 'sinatra/base'
require 'puma'
require 'date'
require_relative './services/request_processor'
require_relative './config'
require_relative 'app'

# Server class that handles the API requests
class Server < Sinatra::Base
  get '/api/v1/stationboards/:region/:stop' do
    mimetype = request.env['HTTP_ACCEPT']
    stop = params['stop']
    date = params['date'] || Date.today.to_s
    region = params['region']

    external_api_method = "#{request.env['REQUEST_METHOD'].downcase}_stationboard"

    request_processor = construct_request_processor(mimetype: mimetype, country: region, method: external_api_method)

    data = request_processor.process({ stop: stop, date: date }, external_api_method)
    status 200
    content_type 'application/json'
    data
  end

  not_found do
    status 404
    body 'Not found'
  end

  def self.start_server!(port: 8080)
    set :port, port

    run!
  end

  private

  def construct_request_processor(country:, method:, mimetype: 'application/json')
    formatter_class = App.instance.config.formatters[mimetype]

    halt 415, "Unsupported Media Type: #{mimetype}" if formatter_class.nil?

    formatter = formatter_class.new

    region_apis = App.instance.config.region_api[country]
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
