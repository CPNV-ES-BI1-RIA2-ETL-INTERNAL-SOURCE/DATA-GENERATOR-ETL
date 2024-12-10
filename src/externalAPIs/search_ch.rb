class SearchCH
  include ExternalAPI

  def get_stationboard(station, date)
    raise NotImplementedError, 'Method not implemented'
  end

  def get_connections(from, to, date)
    raise NotImplementedError, 'Method not implemented'
  end
end
