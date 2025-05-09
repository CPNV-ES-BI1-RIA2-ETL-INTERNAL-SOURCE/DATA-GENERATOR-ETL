# frozen_string_literal: true

require 'sinatra/base'
require 'date'
require_relative '../controllers/stationboard_controller'
require_relative '../externalAPIs/api_exceptions'

module Routes
  # API routes for the application
  class API < Sinatra::Base
    # Auto-inject dependencies from the container
    include Import[:logger, :config]

    # Use controllers
    helpers StationboardController

    configure do
      disable :show_exceptions
      set :raise_errors, true
    end

    # API routes for stationboards
    get '/api/:v/stationboards/:region/:stop' do
      # Validate API version
      if params['v'][1..params['v'].length] != config['api']['version']
        halt 404, { error: "Unsupported API Version: #{params['v']}", status: 404 }.to_json
      end

      # Get request parameters
      mimetype = request.env['HTTP_ACCEPT']
      stop = params['stop']

      # Parse and validate date if provided
      if params['date']
        unless params['date'].match?(%r{^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{4}$})
          halt 400,
               { error: 'Invalid Date Format',
                 status: 400 }.to_json
        end
        date = params['date']
      else
        date = Date.today.to_s
      end

      # Get region and mode parameters
      region = params['region']
      mode = params['mode'] || 'departures'

      # Build the external API method name
      external_api_method = "#{request.env['REQUEST_METHOD'].downcase}_stationboard"

      # Process the request using the stationboard controller
      response = get_stationboard(
        mimetype: mimetype,
        region: region,
        stop: stop,
        date: date,
        mode: mode,
        method: external_api_method
      )

      # Set content type from the controller response and return data
      content_type response[:content_type]
      response[:content]
    end
  end
end
