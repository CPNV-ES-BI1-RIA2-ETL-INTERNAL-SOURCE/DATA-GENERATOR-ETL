# frozen_string_literal: true

require 'sinatra/base'
require 'puma'
require 'pathname'
require 'date'

# Load configuration
require_relative 'src/config'
require_relative 'src/container'

# Load routes and middleware
require_relative 'src/routes/api'
require_relative 'src/middleware/error_handler'
require_relative 'src/middleware/logger'

# Main application class
class App < Sinatra::Base
  # Include dependency injection
  include Import[:logger, :config]

  # Setup the application
  def self.setup
    # Configure application
    setup_container
    setup_server_settings
  end

  # Configuration settings
  configure do
    set :root, File.dirname(__FILE__)
    set :show_exceptions, false
    enable :logging
  end

  # Register middleware
  use Middleware::Logger
  use Middleware::ErrorHandler

  # Register routes
  use Routes::API

  get '/' do
    content_type :json
    { status: 'ok', version: config['api']['version'] }.to_json
  end

  get '/health' do
    content_type :json
    { status: 'ok', timestamp: Time.now.utc }.to_json
  end

  # 404 handler
  not_found do
    content_type :json
    status 404
    { error: 'Not found', status: 404 }.to_json
  end

  # Setup dependency container
  def self.setup_container
    register_configurations
    register_services
    register_formatters
    register_apis
  end

  # Configure server settings
  def self.setup_server_settings
    set :port, ENV.fetch('PORT', 8000)
    set :bind, '0.0.0.0'
  end

  # Register configuration objects
  def self.register_configurations
    Container.register(:config, memoize: true) { Config.new }
    Container.register(:logger, memoize: true) do
      require_relative 'src/services/logger/multi_logger'
      MultiLogger.new
    end
  end

  # Register application services
  def self.register_services
    Container.register(:bucket_service, memoize: true) do
      require_relative 'src/services/bucket_adapter'
      Services::BucketAdapter.new Container[:config]['storage']['url']
    end

    Container.register(:request_processor, memoize: false) do |formatter, external_api|
      require_relative 'src/services/request_processor'
      RequestProcessor.new(formatter, external_api)
    end
  end

  # Register response formatters
  def self.register_formatters
    Container.register(:json_formatter, memoize: true) do
      require_relative 'src/formatters/json_formatter'
      JsonFormatter.new
    end

    Container.register(:xml_formatter, memoize: true) do
      require_relative 'src/formatters/xml_formatter'
      XmlFormatter.new
    end

    Container.register(:pdf_formatter, memoize: true) do
      require_relative 'src/formatters/pdf_formatter'
      PdfFormatter.new
    end
  end

  # Register external API clients
  def self.register_apis
    Container.register(:search_ch_api, memoize: true) do
      require_relative 'src/externalAPIs/search_ch'
      SearchCh.new
    end
  end
end

# Setup the application when this file is loaded
App.setup
