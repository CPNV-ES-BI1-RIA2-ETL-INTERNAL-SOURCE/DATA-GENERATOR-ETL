# frozen_string_literal: true

module SearchApiResponse
  def self.response(query_params)
    {
      stop: create_stop(query_params[:stop]),
      connections: create_connections(query_params[:date])
    }
  end
  
  def self.create_stop(stop_name)
    {
      id: '8504200',
      name: stop_name,
      type: 'train',
      x: '539084',
      y: '181463',
      lon: 6.640943,
      lat: 46.78155
    }
  end
  
  def self.create_connections(date)
    [
      {
        time: "#{date}T00:31:00",
        type: 'train',
        line: 'R',
        operator: 'SBB',
        color: 'ff0000',
        type_name: 'Regio',
        terminal: create_terminal,
        track: '1',
        subsequent_stops: create_subsequent_stops
      }
    ]
  end
  
  def self.create_terminal
    {
      id: '8504201',
      name: 'Grandson',
      x: 539_084,
      y: 181_463,
      lon: 6.641953,
      lat: 46.806287
    }
  end
  
  def self.create_subsequent_stops
    [
      {
        id: '8504201',
        name: 'Grandson',
        x: 539_084,
        y: 181_463,
        lon: 6.641953,
        lat: 46.806287,
        arr: '1970-01-01T00:36:00',
        dep: nil
      }
    ]
  end
end
