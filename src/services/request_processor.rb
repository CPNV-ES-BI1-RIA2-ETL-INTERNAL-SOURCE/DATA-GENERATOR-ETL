# frozen_string_literal: true

require_relative '../container'
require_relative '../externalAPIs/api_exceptions'

# RequestProcessor class for handling API requests and formatting responses
class RequestProcessor
  attr_reader :formatter, :external_api, :logger

  include Import[:logger]

  def initialize(formatter, external_api, **deps)
    @formatter = formatter
    @external_api = external_api
    @logger = deps[:logger]
  end

  def process(options, method)
    logger.info("Processing request with options: #{options}, method: #{method}")
    begin
      data = @external_api.send(method, options)
      @formatter.format(data)
    rescue ApiExceptions::ApiError => e
      # Pass on the custom API exceptions with their status code and details
      # so they can be handled by the error middleware
      logger.error("API Error: #{e.message}, Status Code: #{e.status_code}, Details: #{e.details}")
      raise e
    rescue NoMethodError => e
      logger.error("API method not available: #{method}, Error: #{e.message}")
      raise ApiExceptions::InvalidRequestError.new('Requested API method is not available', {
                                                     method: method,
                                                     options: options,
                                                     original_error: e.message
                                                   })
    rescue StandardError => e
      logger.error("Unexpected error processing request: #{e.message}")
      raise ApiExceptions::ApiError.new('Error processing request', 500, {
                                          original_error: e.message,
                                          method: method,
                                          options: options
                                        })
    end
  end
end
