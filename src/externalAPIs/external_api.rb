# frozen_string_literal: true
require 'httparty'

class ExternalAPI
  include HTTParty

  def initialize(options)
    @options = options
  end
end
