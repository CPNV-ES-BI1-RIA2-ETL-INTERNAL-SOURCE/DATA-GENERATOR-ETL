# frozen_string_literal: true

require 'dry/struct'
require 'dry/types'

module Types
  include Dry.Types()
end

module Models
  # Departure model representing a single departure
  class Departure < Dry::Struct
    attribute :time, Types::String
    attribute :destination, Types::String
    attribute :platform, Types::String.optional
    attribute :category, Types::String
    attribute :line, Types::String.optional
    attribute :operator, Types::String.optional
  end

  # Stationboard model representing a collection of departures for a station
  class Stationboard < Dry::Struct
    attribute :station, Types::String
    attribute :date, Types::String
    attribute :departures, Types::Array.of(Departure)

    # Create a stationboard from raw API data
    # @param data [Hash] The raw API data
    # @return [Stationboard] The stationboard object
    def self.from_api_data(data)
      station = data['station'] || 'Unknown'
      date = data['date'] || Time.now.strftime('%Y-%m-%d')

      departures = (data['departures'] || []).map do |departure|
        Departure.new(
          time: departure['time'] || 'Unknown',
          destination: departure['destination'] || 'Unknown',
          platform: departure['platform'],
          category: departure['category'] || 'Unknown',
          line: departure['line'],
          operator: departure['operator']
        )
      end

      new(
        station: station,
        date: date,
        departures: departures
      )
    end
  end
end
