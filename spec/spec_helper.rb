require 'rack/test'
require 'rspec'
require 'simplecov'
require 'pdf/inspector'

# Start SimpleCov for test coverage reporting
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

# Set test environment
ENV['RACK_ENV'] = 'test'

# Require the application
require_relative '../app'

# Configure RSpec
RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed

  # Define app for Rack::Test
  def app
    App
  end
end 