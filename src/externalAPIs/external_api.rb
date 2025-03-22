# frozen_string_literal: true

require 'httparty'

# Base class for external API integrations
class ExternalAPI
  include HTTParty

  def initialize
    @options = {}
  end
end
