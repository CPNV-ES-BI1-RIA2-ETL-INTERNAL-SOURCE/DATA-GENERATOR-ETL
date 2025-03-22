# frozen_string_literal: true

require 'json'
require 'nokogiri'

# XMLFormatter class for converting data to XML format
class XMLFormatter
  def format(data)
    json = data[:response].parsed_response.to_json
    parsed_data = JSON.parse(json)
    json_to_xml(parsed_data)
  end

  private

  def json_to_xml(data, root_name = 'root')
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.send(root_name) do
        parse_json_object(data, xml)
      end
    end
    builder.to_xml
  end

  def parse_json_object(data, xml)
    case data
    when Hash
      process_hash(data, xml)
    when Array
      process_array(data, xml)
    else
      xml.text(data)
    end
  end

  def process_hash(hash, xml)
    hash.each do |key, value|
      xml.send(key.to_s.gsub('*', '_')) { parse_json_object(value, xml) }
    end
  end

  def process_array(array, xml)
    array.each do |item|
      xml.send('item') { parse_json_object(item, xml) }
    end
  end
end
