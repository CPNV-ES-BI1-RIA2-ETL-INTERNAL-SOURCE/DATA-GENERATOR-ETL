require 'json'
require 'nokogiri'

class XMLFormatter
  def format(data)
    json = data[:response].parsed_response.to_json
    parsed_data = JSON.parse(json)
    json_to_xml(parsed_data)
  end

  private

  def json_to_xml(data, root_name = 'root')
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.send(root_name) {
        parse_json_object(data, xml)
      }
    end
    builder.to_xml
  end

  def parse_json_object(data, xml)
    case data
    when Hash
      data.each do |key, value|
        if key.to_s.include?('*')
          xml.send(key.to_s, value)
        else
          xml.send(key.to_s) { parse_json_object(value, xml) }
        end
      end
    when Array
      data.each do |item|
        xml.send('item') { parse_json_object(item, xml) }
      end
    else
      xml.text(data)
    end
  end
end
