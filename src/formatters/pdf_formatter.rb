# frozen_string_literal: true

require_relative '../helpers/date'
require_relative '../container'
require_relative 'pdf/timetable_formatter'
require_relative 'pdf/file_manager'
require_relative 'pdf/response_builder'

# PDFFormatter class for converting data to PDF format
class PDFFormatter
  include Import[:logger, :bucket_service, :config]

  attr_accessor :destination_data_structure, :origin_data_structure

  def initialize(origin_data_structure = {}, **deps)
    @origin_data_structure = origin_data_structure
    @destination_data_structure = {}

    @logger = deps[:logger]
    @bucket_service = deps[:bucket_service]
    @config = deps[:config]

    @timetable_formatter = PDF::TimetableFormatter.new
    @file_manager = PDF::FileManager.new
    @response_builder = PDF::ResponseBuilder.new
  end

  # @param data [StationBoardResponse]
  def format(data)
    request = data[:request]
    data = data[:formatted_response]
    return unless data.instance_of?(StationBoardResponse)

    date = DateTime.parse(data.connections[0].time)

    @logger.debug("Starting PDF generation for #{request[:stop]}")
    tt = @timetable_formatter.create_timetable(data, date)
    content = tt.render
    @logger.debug("PDF generation for #{request[:stop]} finished")

    filename = @file_manager.generate_filename(date, request)
    upload_url = @bucket_service.upload(content, filename).url

    @response_builder.create_response(upload_url)
  end
end
