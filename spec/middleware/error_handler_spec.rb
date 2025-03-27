# frozen_string_literal: true

require 'spec_helper'
require_relative '../../src/middleware/error_handler'
require_relative '../../src/externalAPIs/api_exceptions'

RSpec.describe Middleware::ErrorHandler do
  
  it 'defines error handlers for ApiExceptions::ApiError' do
    expect(described_class.errors).to have_key(ApiExceptions::ApiError)
  end

  it 'defines generic error handlers' do
    # A default handler (nil) or a 500 status code handler should exist
    default_handlers = [
      described_class.errors.has_key?(nil),
      described_class.errors.has_key?(500) 
    ]
    
    expect(default_handlers).to include(true)
  end
  
  it 'defines specific HTTP status code handlers' do
    # Check for common HTTP status code handlers
    [400, 404, 415].each do |code|
      expect(described_class.errors).to have_key(code)
    end
  end
  
  # Using the WebMock approach
  describe 'integration with app', type: :integration do
    include Rack::Test::Methods
    
    let(:app) { App }
  end
end 