# frozen_string_literal: true

require 'yaml'
require 'json'
require_relative './externalAPIs/search_ch'
require_relative './formatters/json_formatter'
require_relative './formatters/pdf_formatter'
require_relative './formatters/xml_formatter'

# Config class that holds the configuration of the server mainly the static data
class Config
  attr_reader :region_api, :accepted_mimetypes, :formatters, :config_data

  def initialize(config_file = 'config.yml')
    load_config(config_file)
    setup_api_mapping
    setup_formatters
  end

  def [](key)
    @config_data[key]
  end

  private

  def load_config(config_file)
    cf = File.open(config_file).read
    ENV.each do |k, v|
      cf.gsub! "${#{k}}", v
    end

    @config_data = YAML.load(cf)
  end

  def setup_api_mapping
    @region_api = {
      'CH' => [SearchAPI]
    }
    @accepted_mimetypes = ['application/json', 'application/pdf']
  end

  def setup_formatters
    @formatters = {}
    @config_data['formatters'].each do |formatter|
      @formatters[formatter['type']] = Object.const_get(formatter['class'])
    end
  end
end
