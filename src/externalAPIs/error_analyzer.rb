# frozen_string_literal: true

require_relative 'api_exceptions'

# Utility class for analyzing API error messages and creating appropriate exceptions
class ErrorAnalyzer
  # Analyze error messages to determine the type of error
  # @param messages [Array<String>] The error messages from the API
  # @param options [Hash] The request options (containing stop ID, date, etc.)
  # @return [ApiExceptions::ApiError] The appropriate exception instance
  def self.analyze(messages, options)
    stop_id = options[:stop]
    combined_message = messages.join(' ')

    # Check for station not found
    if station_not_found?(combined_message, stop_id)
      return ApiExceptions::StationNotFoundError.new(stop_id, {
                                                       api_messages: messages,
                                                       request: options
                                                     })
    end

    # Check for date format errors
    if date_format_error?(combined_message)
      return ApiExceptions::InvalidRequestError.new('Invalid date format in request', {
                                                      api_messages: messages,
                                                      request: options
                                                    })
    end

    # Default to general API error
    ApiExceptions::ExternalApiError.new("External API returned an error: #{messages.join(', ')}", {
                                          api_messages: messages,
                                          request: options
                                        })
  end

  # Check if the error message indicates a station not found error
  # @param message [String] The combined error message
  # @param stop_id [String] The station ID
  # @return [Boolean] True if the message indicates a station not found error
  def self.station_not_found?(message, stop_id)
    patterns = [
      /stop\s+#{Regexp.escape(stop_id)}\s+not\s+found/i,
      /haltestelle\s+#{Regexp.escape(stop_id)}\s+nicht\s+gefunden/i,
      /station\s+#{Regexp.escape(stop_id)}\s+introuvable/i,
      /#{Regexp.escape(stop_id)}.*not found/i,
      /#{Regexp.escape(stop_id)}.*nicht gefunden/i,
      /#{Regexp.escape(stop_id)}.*introuvable/i,
      /nicht gefunden/i
    ]

    patterns.any? { |pattern| message.match?(pattern) }
  end

  # Check if the error message indicates a date format error
  # @param message [String] The combined error message
  # @return [Boolean] True if the message indicates a date format error
  def self.date_format_error?(message)
    patterns = [
      /Unknown time format/i,
      /invalid date/i,
      /ungültiges datum/i,
      /date invalide/i
    ]

    patterns.any? { |pattern| message.match?(pattern) }
  end
end
