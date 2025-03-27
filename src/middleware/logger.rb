# frozen_string_literal: true

require 'sinatra/base'
require_relative '../container'

module Middleware
  # Logger middleware for the application
  class Logger < Sinatra::Base
    include Import[:logger]

    # Log requests before they are processed
    before do
      logger.info("Request: #{request.request_method} #{request.path_info}")
      logger.info("Params: #{params.inspect}")
    end

    # Log responses after they are processed
    after do
      logger.info("Response: #{response.status}")
    end
  end
end
