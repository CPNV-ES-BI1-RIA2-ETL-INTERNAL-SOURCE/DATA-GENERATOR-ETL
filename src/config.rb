# frozen_string_literal: true

require 'yaml'
require 'json'
require_relative './externalAPIs/search_ch'
require_relative './formatters/json_formatter'
require_relative './formatters/pdf_formatter'
require_relative './formatters/xml_formatter'

# Config class that holds the configuration of the server mainly the static data
class Config

  attr_reader :region_api, :accepted_mimetypes, :formatters

  def initialize
    @config = YAML.load_file('config.yml')
    @region_api = {
      'CH' => [SearchAPI]
    }
    @accepted_mimetypes = ['application/json', 'application/pdf']

    @formatters = {}

    @config['formatters'].each do |formatter|
      @formatters[formatter['type']] = Object.const_get(formatter['class'])
    end
  end

  def [](key)
    @config[key]
  end
end
