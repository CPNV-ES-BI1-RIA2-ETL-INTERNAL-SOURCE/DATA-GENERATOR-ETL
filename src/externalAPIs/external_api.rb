# frozen_string_literal: true

require 'httparty'
require_relative 'api_exceptions'

# Base class for external API integrations
class ExternalAPI
  include HTTParty

  def initialize
    @options = {}
  end

  protected

  # Parse JSON response with error handling
  # @param response [HTTParty::Response] The API response
  # @return [Hash] The parsed response
  def parse_json_response(response)
    JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError => e
    raise ApiExceptions::InvalidResponseError.new('Invalid response format', {
                                                    original_error: e.message,
                                                    response_body: response&.body&.to_s&.[](0..500)
                                                  })
  end

  # Handle a failed API request
  # @param error [StandardError] The caught exception
  # @param options [Hash] The request options
  # @param response [HTTParty::Response, nil] The API response if available
  # @raise [ApiExceptions::ExternalApiError] A formatted API exception
  def handle_request_error(error, options, response = nil)
    raise ApiExceptions::ExternalApiError.new('API request failed', {
                                                original_error: error.message,
                                                request_options: options,
                                                response_body: response&.body&.to_s&.[](0..500)
                                              })
  end
end
