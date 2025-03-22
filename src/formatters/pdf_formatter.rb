# frozen_string_literal: true

require_relative 'templates/timetable'
require_relative '../helpers/date'
require_relative '../container'

# PDFFormatter class for converting data to PDF format
class PDFFormatter
  include Import[:logger, :bucket_service, :config]

  attr_accessor :destination_data_structure, :origin_data_structure

  def initialize(origin_data_structure = {}, **deps)
    @origin_data_structure = origin_data_structure
    @destination_data_structure = {}

    # Explicitly set the dependencies to instance variables
    @logger = deps[:logger]
    @bucket_service = deps[:bucket_service]
    @config = deps[:config]
  end

  # @param data [StationBoardResponse]
  def format(data)
    request = data[:request]
    data = data[:formatted_response]
    return unless data.instance_of?(StationBoardResponse)

    date = DateTime.parse(data.connections[0].time)
    tt = create_timetable(data, date)

    @logger.debug("Starting PDF generation for #{request[:stop]}")
    content = tt.render
    @logger.debug("PDF generation for #{request[:stop]} finished")

    filename = filenamer(date, request)

    create_response(@bucket_service.upload(content, filename).url)
  end

  def create_timetable(data, date)
    tt = Timetable.new
    tt.draw_logo File.expand_path('../../assets/images/sbb-logo.png', __dir__)
    tt.headers = ['<b>Heure de départ</b>', '<b>Ligne</b>', '<b>Destination</b>', '<b>Vias</b>', '<b>Voie</b>']
    tt.stop = data.stop
    tt.draw_heading(date)
    tt.draw_table({ column_widths: [110, 50, 150, 2940, 50] }) do
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

  def filenamer(date, request)
    "#{date.strftime('%Y-%m-%d')}/#{request[:stop]}.pdf"
  end

  def create_response(url)
    { 'status' => 'created', 'file' => url }.to_json
  end
end
