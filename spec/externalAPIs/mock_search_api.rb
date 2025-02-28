require_relative '../../src/externalAPIs/models/stationboard_response'
require_relative '../data/search_api_response'

class MockSearchAPI
  def initialize(options = {})
    puts "Initializing MockSearchAPI with options: #{options.inspect}"
    @options = { :query => { :show_tracks => '1', :show_subsequent_stops => '1', :time => '00:01' } }
  end

  def get_stationboard(options)
    puts "Called stationboard with station: #{options.inspect}"
    @options[:query].merge! options
    puts "Query parameters prepared: #{@options[:query].inspect}"
    StationBoardResponse.new mock_response(@options[:query])
  end

  private

  # TODO - data must be separated from test logic.
  def mock_response(query_params)
    puts "Mocking response for query parameters: #{query_params.inspect}"
    SearchApiResponse.response(query_params)
  end
end
