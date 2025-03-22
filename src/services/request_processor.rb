# frozen_string_literal: true

require_relative '../container'
require_relative '../app'

# RequestProcessor class for handling API requests and formatting responses
class RequestProcessor
  # In a real implementation, you would register formatter and external_api in the container
  # and inject them here. This is just an example of how it would work.
  attr_reader :formatter, :external_api, :logger

  # Auto-inject dependencies from the container
  include Import[:logger]

  # Initialize with dependencies
  def initialize(formatter, external_api, **deps)
    @formatter = formatter
    @external_api = external_api
    # Logger is auto-injected through Import
    @logger = deps[:logger]
  end

  def process(options, method)
    logger.info("Processing request with options: #{options}, method: #{method}")
    data = @external_api.send(method, options)
    @formatter.format(data)
  end
end
