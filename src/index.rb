# frozen_string_literal: true

require 'dotenv/load'
require 'argv'
require_relative 'app'

# TODO: NGY - regarding the readme file, port number comes from argument command line (run server)
# Is it a "default" value in "case of" ?
# ANSWER DRZ - The port number is a default value in case the user does not provide a port number as an argument.

# Default port from environment variable
# Command line argument takes precedence over environment variable
ENV['PORT'] = ARGV.to_hash['p'] if ARGV.to_hash['p']

if !ENV.key?('APP_ENV') || ENV['APP_ENV'].nil?
  ENV['APP_ENV'] = 'development' if ARGV.short_options.include?('d') || ARGV.long_options.any? do |i|
    %w[dev development].include?(i)
  end
  ENV['APP_ENV'] = 'test' if ARGV.short_options.include?('t') || ARGV.long_options.include?('test')
  ENV['APP_ENV'] = 'production' unless ENV.key?('APP_ENV')
end

App.instance
App.run
