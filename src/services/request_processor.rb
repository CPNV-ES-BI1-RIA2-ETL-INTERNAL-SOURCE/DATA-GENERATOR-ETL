class RequestProcessor
  attr_reader :formater, :external_api

  def initialize(formater, external_api)
    @formater = formater
    @external_api = external_api
  end

  def process
    raise NotImplementedError, 'Method not implemented'
  end
end
