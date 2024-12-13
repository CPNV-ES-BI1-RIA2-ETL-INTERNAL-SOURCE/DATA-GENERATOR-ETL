require_relative 'external_api'

class SearchAPI < ExternalAPI
  base_uri 'search.ch'

  def initialize(options)
    super(options)
    @options = { query: { show_tracks: "1", show_subsequent_stops: "1", time: '00:01' } }
  end

  def get_stationboard(options)
    @options[:query].merge! options
    self.class.get'/timetable/api/stationboard.json', @options
  end

  def get_connections(from, to, date)
    raise NotImplementedError, 'Method not implemented'
  end
end
