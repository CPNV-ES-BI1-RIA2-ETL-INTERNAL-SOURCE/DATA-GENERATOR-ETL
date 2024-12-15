require_relative 'external_api'
require_relative 'models/stationboard_response'

class SearchAPI < ExternalAPI
  base_uri 'search.ch'

  def initialize(options)
    super(options)
    @options = { query: { show_tracks: "1", show_subsequent_stops: "1", time: '00:01' } }
  end

  def get_stationboard(options)
    @options[:query].merge! options
    response = self.class.get('/timetable/api/stationboard.json', @options)
    {:response => response, :formatted_response => StationBoardResponse.new(JSON.parse(response.body, symbolize_names: true))}
  end

  def get_connections(from, to, date)
    raise NotImplementedError, 'Method not implemented'
  end
end
