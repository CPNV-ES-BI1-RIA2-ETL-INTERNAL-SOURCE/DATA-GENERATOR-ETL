require_relative '../../src/externalAPIs/models/stationboard_response'

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

  def mock_response(query_params)
    puts "Mocking response for query parameters: #{query_params.inspect}"
    {
      :stop => {
        :id => "8504200",
        :name => query_params[:stop],
        :type => "train",
        :x => "539084",
        :y => "181463",
        :lon => 6.640943,
        :lat => 46.78155
      },
      :connections => [
        {
          :time => "#{query_params[:date]}T00:31:00",
          :type => "train",
          :line => "R",
          :operator => "SBB",
          :color => "ff0000",
          :type_name => "Regio",
          :terminal => {
            :id => "8504201",
            :name => "Grandson",
            :x => 539084,
            :y => 181463,
            :lon => 6.641953,
            :lat => 46.806287
          },
          :track => "1",
          :subsequent_stops => [
            {
              :id => "8504201",
              :name => "Grandson",
              :x => 539084,
              :y => 181463,
              :lon => 6.641953,
              :lat => 46.806287,
              :arr => "1970-01-01T00:36:00",
              :dep => nil
            }
          ]
        }
      ]
    }
  end
end
