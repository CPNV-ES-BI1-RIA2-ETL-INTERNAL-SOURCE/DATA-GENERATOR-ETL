class JSONFormater
  attr_accessor :destination_data_structure, :origin_data_structure

  def initialize(origin_data_structure = {})
    @origin_data_structure = origin_data_structure
    @destination_data_structure = {}
  end

  def format(data)
    raise NotImplementedError, 'Method not implemented'
  end
end