# frozen_string_literal: true

require 'sinatra/base'
require_relative '../container'
require_relative '../externalAPIs/api_exceptions'

module Middleware
  # Error handler middleware for the application
  class ErrorHandler < Sinatra::Base
    include Import[:logger]

    configure do
      disable :show_exceptions
      set :raise_errors, false
    end

    error ApiExceptions::ApiError do
      e = env['sinatra.error']

      content_type :json
      status e.status_code

      {
        error: e.message,
        status: e.status_code,
        type: e.class.name.split('::').last,
        details: e.details
      }.to_json
    end

    error do
      e = env['sinatra.error']
      logger.error("Erreur non gérée: #{e.message}")
      logger.error(e.backtrace.join("\n")) if e.backtrace

      content_type :json
      status 500

      {
        error: e.message,
        status: 500,
        type: 'InternalServerError'
      }.to_json
    end

    error 400 do
      content_type :json
      {
        error: env['sinatra.error']&.message || 'Bad Request',
        status: 400,
        type: 'BadRequestError'
      }.to_json
    end

    error 404 do
      content_type :json
      {
        error: env['sinatra.error']&.message || 'Not Found',
        status: 404,
        type: 'NotFoundError'
      }.to_json
    end

    error 415 do
      content_type :json
      {
        error: env['sinatra.error']&.message || 'Unsupported Media Type',
        status: 415,
        type: 'UnsupportedMediaTypeError'
      }.to_json
    end

    error 500 do
      content_type :json
      {
        error: env['sinatra.error']&.message || 'Internal Server Error',
        status: 500,
        type: 'InternalServerError'
      }.to_json
    end
  end
end
