class Server
  def run
    raise NotImplementedError, 'Method not implemented'
  end

  private

  def construct_request
    raise NotImplementedError, 'Method not implemented'
  end

  def process_request
    raise NotImplementedError, 'Method not implemented'
  end

  def handle_request
    raise NotImplementedError, 'Method not implemented'
  end

  def define_routes
    raise NotImplementedError, 'Method not implemented'
  end
end
