# frozen_string_literal: true

require 'date'
require_relative '../templates/timetable'
require_relative '../templates/document_adapter'

module PDF
  # Responsible for formatting timetable data
  class TimetableFormatter
    def create_timetable(data, date, config = {})
      default_config = {
        document_adapter: DocumentGenerators::PrawnAdapter,
        column_widths: [110, 50, 150, 2940, 50],
        headers: ['<b>Heure de départ</b>', '<b>Ligne</b>', '<b>Destination</b>', '<b>Vias</b>', '<b>Voie</b>']
      }
      
      merged_config = default_config.merge(config)
      
      tt = Timetable.new(merged_config)
      tt.draw_logo File.expand_path('../../../assets/images/sbb-logo.png', __dir__)
      tt.headers = merged_config[:headers]
      tt.stop = data.stop
      tt.draw_heading(date)
      tt.draw_table({ column_widths: merged_config[:column_widths] }) do
        format_connections_data(data.connections)
      end
      tt
    end

    def format_connections_data(connections)
      connections.map do |connection|
        track = ''
        track = connection.track.value! if connection.track.class != Dry::Monads::Maybe::None
        [
          DateTime.parse(connection.time).strftime('%k %M'),
          connection.line,
          connection.terminal.name,
          connection.subsequent_stops.map(&:name).join(', ').to_s,
          track
        ]
      end
    end
  end
end
