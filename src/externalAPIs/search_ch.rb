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
    StationBoardResponse.new JSON.parse(self.class.get('/timetable/api/stationboard.json', @options).body, symbolize_names: true)
  end

  def get_connections(from, to, date)
    raise NotImplementedError, 'Method not implemented'
  end
end
