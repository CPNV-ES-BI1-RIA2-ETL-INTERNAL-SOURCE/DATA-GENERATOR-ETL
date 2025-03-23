# frozen_string_literal: true

require 'sinatra/base'
require_relative '../container'

module Middleware
  # Error handler middleware for the application
  class ErrorHandler < Sinatra::Base
    include Import[:logger]

    # Handle errors
    error do
      logger.error("Error: #{env['sinatra.error'].message}")
      logger.error(env['sinatra.error'].backtrace.join("\n"))

      content_type :json
      status 500
      
      {
        error: env['sinatra.error'].message,
        status: 500
      }.to_json
    end
    
    # Handle custom errors
    error 400 do
      content_type :json
      { error: env['sinatra.error'] || 'Bad Request', status: 400 }.to_json
    end
    
    error 404 do
      content_type :json
      { error: env['sinatra.error'] || 'Not Found', status: 404 }.to_json
    end
    
    error 415 do
      content_type :json
      { error: env['sinatra.error'] || 'Unsupported Media Type', status: 415 }.to_json
    end
    
    error 500 do
      content_type :json
      { error: env['sinatra.error'] || 'Internal Server Error', status: 500 }.to_json
    end
  end
end 