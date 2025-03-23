# frozen_string_literal: true

require 'singleton'
require 'prawn'
require_relative './config'
require_relative './services/bucket_adapter'
require_relative './services/logger/multi_logger'
require_relative './server'
require_relative 'container'

# Application class responsible for setting up and running the server
class App
  include Singleton

  def initialize
    Prawn::Fonts::AFM.hide_m17n_warning = true

    setup_container
  end

  def self.run
    Server.start_server! unless Server.running?
  end

  private

  def setup_container
    register_basic_components
    register_services
  end

  def register_basic_components
    Container.register(:config, memoize: true) { Config.new }
    Container.register(:logger, memoize: true) { MultiLogger.new }
  end

  def register_services
    Container.register(:bucket_service, memoize: true) do
      Services::BucketAdapter.new Container[:config]['storage']['url']
    end

    # Register the server class
    Container.register(:server, memoize: true) { Server }
  end
end
