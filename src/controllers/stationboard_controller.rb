# frozen_string_literal: true

require_relative '../container'

# Controller for stationboard operations
module StationboardController

  # Get stationboard data
  #
  # @param [Hash] options The options hash
  # @option options [String] :mimetype The mimetype requested
  # @option options [String] :region The region code
  # @option options [String] :stop The station stop ID
  # @option options [String] :date The date (optional)
  # @option options [String] :mode The mode (departures/arrivals)
  # @option options [String] :method The method to call on the external API
  # @return [String] The formatted stationboard data
  def get_stationboard(options)
    # Get the formatter for the requested mimetype
    formatter = get_formatter(options[:mimetype])
    
    # Get the external API for the requested region
    external_api = get_external_api(options[:region], options[:method])
    
    # Create request processor with the formatter and external API
    request_processor = Container['request_processor'].call(formatter, external_api)
    
    # Process the request
    request_processor.process(
      {
        stop: options[:stop],
        date: options[:date],
        mode: options[:mode]
      },
      options[:method]
    )
  end
  
  private
  
  # Get formatter for the requested mimetype
  #
  # @param [String] mimetype The mimetype
  # @return [Object] The formatter instance
  def get_formatter(mimetype)
    config = Container[:config]
    formatter_class = config.formatters[mimetype]
    halt 415, { error: "Unsupported Media Type: #{mimetype}", status: 415 }.to_json if formatter_class.nil?
    
    formatter_class.new
  end
  
  # Get external API for the requested region
  #
  # @param [String] region The region code
  # @param [String] method The method to call on the external API
  # @return [Object] The external API instance
  def get_external_api(region, method)
    config = Container[:config]
    region_apis = config.region_api[region]
    halt 404, { error: 'No Data Found for this request', status: 404 }.to_json if region_apis.nil? || region_apis.empty?
    
    accepted_apis = region_apis.select { |api| valid_api?(api: api, method: method) }
    halt 404, { error: 'No Data Found for this request', status: 404 }.to_json if accepted_apis.empty?
    
    accepted_apis.first.new
  end
  
  # Check if the external API has the requested method
  #
  # @param [Class] api The API class
  # @param [String] method The method to check
  # @return [Boolean] True if the API has the method
  def valid_api?(api:, method:)
    api.method_defined?(method)
  end
end 