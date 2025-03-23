# frozen_string_literal: true

require 'yaml'
require 'json'
require 'dry/validation'
require_relative './externalAPIs/search_ch'
require_relative './formatters/json_formatter'
require_relative './formatters/pdf_formatter'
require_relative './formatters/xml_formatter'

# Config class that holds the configuration of the server mainly the static data
class Config
  ConfigError = Class.new(StandardError)
  
  attr_reader :region_api, :accepted_mimetypes, :formatters, :config_data

  # Initialize the config with a specific config file
  # @param config_file [String] Path to the config file
  def initialize(config_file = 'config/config.yml')
    load_config(config_file)
    validate_config
    setup_api_mapping
    setup_formatters
  end

  # Access config data using hash-like syntax
  # @param key [String] The config key to access
  # @return [Object] The config value
  def [](key)
    @config_data[key]
  end

  private

  # Load the config file and substitute environment variables
  # @param config_file [String] Path to the config file
  # @raise [ConfigError] If the config file cannot be loaded
  def load_config(config_file)
    begin
      cf = File.open(config_file).read
      ENV.each do |k, v|
        cf.gsub! "${#{k}}", v
      end

      @config_data = YAML.load(cf)
    rescue StandardError => e
      raise ConfigError, "Failed to load config file: #{e.message}"
    end
  end
  
  # Validate the config data using Dry::Validation
  # @raise [ConfigError] If the config is invalid
  def validate_config
    schema = Dry::Schema.Params do
      required(:api).hash do
        required(:version).filled(:string)
      end
      
      required(:formatters).array(:hash) do
        required(:type).filled(:string)
        required(:class).filled(:string)
      end
      
      required(:storage).hash do
        required(:url).filled(:string)
      end
    end
    
    result = schema.call(@config_data)
    raise ConfigError, result.errors.to_h.to_s unless result.success?
  end

  # Setup the region to API class mapping
  def setup_api_mapping
    @region_api = {
      'CH' => [SearchAPI]
    }
    @accepted_mimetypes = ['application/json', 'application/pdf', 'application/xml']
  end

  # Setup the formatters based on the config
  def setup_formatters
    @formatters = {}
    @config_data['formatters'].each do |formatter|
      begin
        @formatters[formatter['type']] = Object.const_get(formatter['class'])
      rescue NameError => e
        raise ConfigError, "Invalid formatter class: #{formatter['class']}"
      end
    end
  end
end
