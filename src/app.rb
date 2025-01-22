# frozen_string_literal: true

require 'singleton'
require 'aws-sdk-s3'
require_relative './config'
require_relative './services/bucket_service'
require_relative './server'

class App
  include Singleton

  attr_reader :config, :container, :bucket_service

  def initialize
    @config = Config.new
    @bucket_service = BucketService.new Aws::S3::Client.new(region: @config['storage']['region'], credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])) , 'dev.data.generator.cld.education'
  end

  def self.run(port: 8080)
    Server::start_server!(port: 8080)
  end

end
