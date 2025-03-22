# frozen_string_literal: true

# spec/spec_helper.rb
require 'rspec'
require 'pdf/inspector'
require_relative '../src/formatters/pdf_formatter'
require_relative '../src/externalAPIs/models/stationboard_response'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
