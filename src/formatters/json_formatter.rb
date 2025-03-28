# frozen_string_literal: true

# JSONFormatter class for converting data to JSON format
class JSONFormatter
  attr_accessor :destination_data_structure, :origin_data_structure

  def format(data)
    data[:response].parsed_response.to_json
  end
end
