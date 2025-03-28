# frozen_string_literal: true

# Module containing custom exceptions for external API interactions
module ApiExceptions
  # Base class for all API-related exceptions
  class ApiError < StandardError
    attr_reader :status_code, :details

    def initialize(message, status_code = 500, details = {})
      @status_code = status_code
      @details = details
      super(message)
    end
  end

  # Exception raised when a requested resource is not found
  class ResourceNotFoundError < ApiError
    def initialize(message, details = {})
      super(message, 404, details)
    end
  end

  # Exception raised when a station is not found
  class StationNotFoundError < ResourceNotFoundError
    def initialize(station_id, details = {})
      super("Station with ID '#{station_id}' not found", details)
    end
  end

  # Exception raised when the API returns invalid data
  class InvalidResponseError < ApiError
    def initialize(message, details = {})
      super(message, 500, details)
    end
  end

  # Exception raised when the API is unavailable or returns an error
  class ExternalApiError < ApiError
    def initialize(message, details = {})
      super(message, 503, details)
    end
  end

  # Exception raised when the request to the API is invalid
  class InvalidRequestError < ApiError
    def initialize(message, details = {})
      super(message, 400, details)
    end
  end
end
