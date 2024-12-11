require 'singleton'
require 'externalAPIs/search_ch'

class Config
  include Singleton

  attr_reader :regionAPI

  def initialize
    @regionAPI = {
      'switzerland' =>  {SearchCH,}
    }
  end
end
