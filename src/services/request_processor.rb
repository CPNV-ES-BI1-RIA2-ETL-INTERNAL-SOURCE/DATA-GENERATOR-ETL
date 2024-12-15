class RequestProcessor
  attr_reader :format, :external_api

  def initialize(formatter, external_api)
    @formatter = formatter
    @external_api = external_api
  end

  def process(options, method)
    data = @external_api.send(method, options)
    @formatter.format(data)
  end
end
