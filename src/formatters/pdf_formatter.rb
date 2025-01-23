require_relative 'templates/timetable'
require_relative '../helpers/date'

class PDFFormatter
  attr_accessor :destination_data_structure, :origin_data_structure

  def initialize(origin_data_structure = {})
    @origin_data_structure = origin_data_structure
    @destination_data_structure = {}
  end

  # @param data [StationBoardResponse]
  def format(data)
    request = data[:request]
    data = data[:formatted_response]
    if data.class == StationBoardResponse
      date = DateTime.parse(data.connections[0].time)
      tt = Timetable.new
      tt.draw_logo File.expand_path('../../assets/images/sbb-logo.png', __dir__)
      tt.headers = ['<b>Heure de départ</b>', '<b>Ligne</b>', '<b>Destination</b>', '<b>Vias</b>', '<b>Voie</b>']
      tt.stop = data.stop
      tt.draw_heading(date)
      tt.draw_table({ :column_widths => [110, 50, 150, 2940, 50] }) do
        data.connections.map do |connection|
          track = ""
          track = connection.track.value! if connection.track.class != Dry::Monads::Maybe::None
          [DateTime.parse(connection.time).strftime('%k %M'), connection.line, connection.terminal.name, connection.subsequent_stops.map { |s| s.name }.join(', ').to_s, track]
        end
      end
      App.instance[:logger].debug("Starting PDF generation for #{request[:stop]}")
      content = tt.render
      App.instance[:logger].debug("PDF generation for #{request[:stop]} finished")
      filename = filenamer date, request
      App.instance[:bucket_service].upload(content, filename, App.instance[:bucket_service].default_bucket)
      create_response filename
    end
  end

  def filenamer(date, request)
    date.strftime('%Y-%m-%d') + '/'+request[:stop]+'.pdf'
  end

  def create_response(filename)
    { 'status' => 'created', 'file' => App.instance[:bucket_service].get_presigned_url(filename), 'validity_duration' => App.instance[:config]['storage']['signed_url_expiration_time'] }.to_json
  end
end
