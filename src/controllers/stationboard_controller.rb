# frozen_string_literal: true

require_relative '../container'
require_relative '../externalAPIs/api_exceptions'

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
  # @return [Hash] The formatted stationboard data and content type
  def get_stationboard(options)
    # Get the formatter for the requested mimetype
    formatter = get_formatter(options[:mimetype])

    # Get the external API for the requested region
    external_api = get_external_api(options[:region], options[:method])

    # Create request processor with the formatter and external API
    request_processor = Container['request_processor'].call(formatter, external_api)

    # Process the request
    content = request_processor.process(
      {
        stop: options[:stop],
        date: options[:date],
        mode: options[:mode]
      },
      options[:method]
    )

    # Get the response content type for the mimetype
    response_content_type = get_response_type(options[:mimetype])

    # Return both content and content_type
    {
      content: content,
      content_type: response_content_type
    }
  end

  private

  # Get formatter for the requested mimetype
  #
  # @param [String] mimetype The mimetype
  # @return [Object] The formatter instance
  def get_formatter(mimetype)
    config = Container[:config]
    formatter_class = config.formatters[mimetype][:class]

    if formatter_class.nil?
      raise ApiExceptions::InvalidRequestError.new(
        "Unsupported Media Type: #{mimetype}",
        { mimetype: mimetype, available_formats: config.formatters.keys }
      )
    end

    formatter_class.new
  rescue NameError => e
    raise ApiExceptions::InvalidResponseError.new(
      "Error creating formatter for mimetype: #{mimetype}",
      { original_error: e.message }
    )
  end

  # Get response format for the requested mimetype
  #
  # @param [String] mimetype The mimetype
  # @return [String] The response content type
  def get_response_type(mimetype)
    config = Container[:config]
    format = config.formatters[mimetype][:response]['type']

    if format.nil?
      raise ApiExceptions::InvalidRequestError.new(
        "Unsupported Media Type: #{mimetype}",
        { mimetype: mimetype, available_formats: config.formatters.keys }
      )
    end

    format
  end

  # Get external API for the requested region
  #
  # @param [String] region The region code
  # @param [String] method The method to call on the external API
  # @return [Object] The external API instance
  def get_external_api(region, method)
    config = Container[:config]
    region_apis = config.region_api[region]

    if region_apis.nil? || region_apis.empty?
      raise ApiExceptions::ResourceNotFoundError.new(
        "Region not supported: #{region}",
        { region: region, available_regions: config.region_api.keys }
      )
    end

    accepted_apis = region_apis.select { |api| valid_api?(api: api, method: method) }

    if accepted_apis.empty?
      raise ApiExceptions::ResourceNotFoundError.new(
        "No API found for region #{region} supporting method #{method}",
        { region: region, method: method, available_apis: region_apis.map(&:name) }
      )
    end

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
