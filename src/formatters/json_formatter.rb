class JSONFormatter
  attr_accessor :destination_data_structure, :origin_data_structure

  def format(data)
    data.to_json
  end
end
