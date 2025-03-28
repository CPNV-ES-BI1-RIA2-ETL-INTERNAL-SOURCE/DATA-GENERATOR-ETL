# frozen_string_literal: true

require_relative 'external_api'
require_relative 'models/stationboard_response'
require_relative 'api_exceptions'
require_relative 'error_analyzer'
require_relative '../container'
require 'json'

# SearchAPI class for interacting with the search.ch API
class SearchAPI < ExternalAPI
  include Import[:logger]

  base_uri 'search.ch'
  DEFAULT_QUERY_PARAMS = { show_tracks: '1', show_subsequent_stops: '1', time: '00:01' }.freeze

  def get_stationboard(options)
    prepare_request_options(options)
    url = '/timetable/api/stationboard.json'

    logger.debug("Call API => url: #{url}, params: #{@options[:query]}")
    response = self.class.get(url, @options)

    parsed_response = parse_json_response(response)
    validate_response(parsed_response, options)

    create_response_object(response, options, parsed_response)
  rescue JSON::ParserError => e
    raise ApiExceptions::InvalidResponseError.new('Invalid response format from the API', {
                                                    original_error: e.message,
                                                    response_body: response&.body&.to_s&.[](0..500)
                                                  })
  rescue ApiExceptions::ApiError => e
    raise e
  rescue StandardError => e
    handle_request_error(e, options, response)
  end

  private

  def prepare_request_options(options)
    @options ||= {}
    @options[:query] = DEFAULT_QUERY_PARAMS.dup
    @options[:query].merge!(options)
  end

  def validate_response(parsed_response, options)
    check_for_error_messages(parsed_response, options)
    check_for_missing_data(parsed_response, options)
  end

  def check_for_error_messages(parsed_response, options)
    return unless parsed_response[:messages] && !parsed_response[:messages].empty?

    raise ErrorAnalyzer.analyze(parsed_response[:messages], options)
  end

  def check_for_missing_data(parsed_response, options)
    return unless parsed_response[:connections].nil? || parsed_response[:stop].nil?

    raise ApiExceptions::InvalidResponseError.new('API response is missing expected data', {
                                                    response: parsed_response,
                                                    request: options
                                                  })
  end

  def create_response_object(response, options, parsed_response)
    {
      response: response,
      request: options,
      formatted_response: StationBoardResponse.new(parsed_response)
    }
  end
end
