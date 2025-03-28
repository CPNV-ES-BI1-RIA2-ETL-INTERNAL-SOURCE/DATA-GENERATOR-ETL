# frozen_string_literal: true

require_relative 'document_adapter'
require_relative '../../helpers/date'

# Timetable class for generating timetable templates
class Timetable
  attr_reader :table_data, :document
  attr_accessor :stop, :config

  def initialize(config = {})
    @table_data = []
    @config = default_config.merge(config)
    setup_document
  end

  def setup_document
    document_options = {
      page_size: @config[:page_size],
      page_layout: @config[:page_layout],
      margin: @config[:margin]
    }

    adapter_class = @config[:document_adapter] || DocumentGenerators::PrawnAdapter
    @document = adapter_class.new(document_options)
  end

  def draw_logo(path)
    @document.image(path, at: @config[:logo_position], width: @config[:logo_width])
  end

  def headers=(headers)
    @table_data.unshift headers
  end

  def draw_table(options = {})
    data = yield
    @table_data += data

    table_options = {
      header: true,
      cell_style: { inline_format: true }
    }

    table_options[:column_widths] = options[:column_widths] if options[:column_widths]

    @document.table(@table_data, table_options)
  end

  def draw_heading(date)
    @document.text("Gare de #{@stop.name}", size: @config[:heading_size], style: @config[:heading_style])
    @document.text("État au #{date.strftime('%d')} #{DateFormatters.get_month(date.strftime('%m'))} #{date.strftime('%Y')}")
    @document.move_down(@config[:heading_spacing])
  end

  def save(filename)
    @document.render_file(filename)
  end

  def render
    @document.render
  end

  private

  def default_config
    {
      page_size: 'A0',
      page_layout: :landscape,
      margin: 30,
      logo_position: [3100, 2320],
      logo_width: 200,
      heading_size: 24,
      heading_style: :bold,
      heading_spacing: 20,
      document_adapter: DocumentGenerators::PrawnAdapter
    }
  end
end
