# frozen_string_literal: true
require 'prawn'
require 'prawn/table'
require 'prawn/text/formatted'
require_relative '../../helpers/date'

class Timetable
  include Prawn::View

  attr :table_data

  def initialize
    super
    @table_data = []
  end

  def document
    @document ||= Prawn::Document.new(page_size: 'A0', page_layout: :landscape, margin: 30)
  end

  def draw_logo(path)
    image path, at: [3100, 2320], width: 200
  end

  def headers= (headers)
    @table_data.unshift headers
  end

  def draw_table(options)
    data = yield
    @table_data += data
    table(@table_data, header: true, column_widths: options[:column_widths], cell_style: { inline_format: true })
  end

  def draw_heading(date)
    text "Gare de #{@stop.name}", size: 24, style: :bold
    text "État au #{date.strftime('%d')} #{DateFormatters::get_month(date.strftime('%m'))} #{date.strftime('%Y')}"
    move_down 20
  end

  def save(filename)
    save_as filename
  end

  def stop=(stop)
    @stop = stop
  end

end
