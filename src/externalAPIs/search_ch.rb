require_relative 'external_api'
require_relative 'models/stationboard_response'
require 'json'

class SearchAPI < ExternalAPI
  base_uri 'search.ch'

  def initialize(options = {})
    super(options)
  end

  def get_stationboard(options)
    @options.merge!({ query: { show_tracks: "1", show_subsequent_stops: "1", time: '00:01' } })
    @options[:query].merge! options
    url = '/timetable/api/stationboard.json'
    App.instance[:logger].debug("Call API => url: #{url}, params: #{@options[:query]}")
    # TODO NGY - use the url variable set in line 15
    response = self.class.get('/timetable/api/stationboard.json', @options)
    App.instance[:logger].debug("Response for #{url}, content: #{response.body[0..100]}")
    {:response => response, :request => options, :formatted_response => StationBoardResponse.new(JSON.parse(response.body, symbolize_names: true))}
  end

  # TODO - either implement or remove it
  def get_connections(from, to, date)
    raise NotImplementedError, 'Method not implemented'
  end
end
