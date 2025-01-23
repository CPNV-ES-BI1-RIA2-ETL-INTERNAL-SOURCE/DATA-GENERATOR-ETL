# frozen_string_literal: true

require 'singleton'
require 'aws-sdk-s3'
require 'prawn'
require_relative './config'
require_relative './services/bucket_service'
require_relative './server'
require_relative './services/logger/multi_logger'
require_relative './dependency_injection/di'

class App
  include Singleton

  attr_reader :config, :container, :bucket_service

  def initialize
    @container = DI::Container.new

    Prawn::Fonts::AFM.hide_m17n_warning = true
    @container.register :config, Config.new
    @container.register :bucket_service, BucketService.new(Aws::S3::Client.new(region: @container[:config]['storage']['region'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])), 'dev.data.generator.cld.education')
    @container.register :logger, MultiLogger.new
  end

  def self.run(port: 8080)
    Server::start_server!(port: port)
  end

  def [](key)
    @container.resolve(key)
  end

end
