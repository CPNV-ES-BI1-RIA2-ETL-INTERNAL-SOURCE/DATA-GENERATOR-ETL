# frozen_string_literal: true

require 'json'

module PDF
  # Responsible for building response objects
  class ResponseBuilder
    def create_response(url)
      { 'status' => 'created', 'file' => url }.to_json
    end
  end
end 