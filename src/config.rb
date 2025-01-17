# frozen_string_literal: true

require 'singleton'
require_relative './externalAPIs/search_ch'
require_relative './formatters/json_formatter'
require_relative './formatters/pdf_formatter'

# Config class that holds the configuration of the server mainly the static data
class Config
  include Singleton

  attr_reader :region_api, :accepted_mimetypes, :formatters

  def initialize
    @region_api = {
      'CH' => [SearchAPI]
    }
    @accepted_mimetypes = ['application/json', 'application/pdf']
    @formatters = {
      'application/json' => JSONFormatter,
      'application/pdf' => PDFFormatter
    }
  end
end
