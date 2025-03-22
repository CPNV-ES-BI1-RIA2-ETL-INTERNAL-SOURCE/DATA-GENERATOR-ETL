# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require 'dry-monads'

Dry::Types.load_extensions(:maybe)

# Types module providing data structures for stationboard responses
module Types
  include Dry.Types
end

# Classe représentant les informations d'un arrêt
class Stop < Dry::Struct
  attribute :id, Types::String
  attribute :name, Types::String
  attribute :type, Types::String
  attribute :x, Types::String
  attribute :y, Types::String
  attribute :lon, Types::Float
  attribute :lat, Types::Float
end

# Classe représentant un arrêt suivant dans une connexion
class SubsequentStop < Dry::Struct
  attribute :id, Types::String
  attribute :name, Types::String
  attribute :x, Types::Integer.optional
  attribute :y, Types::Integer.optional
  attribute :lon, Types::Float
  attribute :lat, Types::Float
  attribute :arr, Types::String.optional # ISO8601 format
  attribute :dep, Types::String.optional # ISO8601 format
end

# Classe représentant les informations du terminal d'une connexion
class Terminal < Dry::Struct
  attribute :id, Types::String
  attribute :name, Types::String
  attribute :x, Types::Integer.optional
  attribute :y, Types::Integer.optional
  attribute :lon, Types::Float
  attribute :lat, Types::Float
end

# Classe représentant une connexion
class Connection < Dry::Struct
  attribute :time, Types::String # ISO8601 format
  attribute :type, Types::String
  attribute :line, Types::String
  attribute :operator, Types::String
  attribute :color, Types::String.optional
  attribute :type_name, Types::String
  attribute :track, Types::String.maybe
  attribute :terminal, Terminal
  attribute :subsequent_stops, Types::Array.of(SubsequentStop).optional
end

# Classe représentant la réponse complète de la stationboard
class StationBoardResponse < Dry::Struct
  attribute :stop, Stop
  attribute :connections, Types::Array.of(Connection)
end
