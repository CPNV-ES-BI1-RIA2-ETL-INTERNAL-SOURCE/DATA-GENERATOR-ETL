# frozen_string_literal: true

require 'singleton'
require 'aws-sdk-s3'
require 'prawn'
require_relative './config'
require_relative './services/bucket_service'
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
    register_aws_client
    register_services
  end

  def register_basic_components
    Container.register(:config, memoize: true) { Config.new }
    Container.register(:logger, memoize: true) { MultiLogger.new }
  end

  def register_aws_client
    Container.register(:aws_s3_client, memoize: true) do
      config = Container[:config]
      Aws::S3::Client.new(
        region: config['storage']['region'],
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
      )
    end
  end

  def register_services
    Container.register(:bucket_service, memoize: true) do
      aws_client = Container[:aws_s3_client]
      BucketService.new(aws_client, 'dev.data.generator.cld.education')
    end

    # Register the server class
    Container.register(:server, memoize: true) { Server }
  end
end
