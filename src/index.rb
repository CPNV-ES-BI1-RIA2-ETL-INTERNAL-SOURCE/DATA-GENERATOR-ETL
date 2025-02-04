# frozen_string_literal: true
require 'dotenv/load'
require 'argv'
require_relative 'app'

port = 8088

port = ARGV.to_hash['p'].to_i if ARGV.to_hash['p']
ENV['APP_ENV'] = 'development' if ARGV.short_options.include?('d') || ARGV.long_options.any? { |i| %w[dev development].include?(i) }
ENV['APP_ENV'] = 'test' if ARGV.short_options.include?('t') || ARGV.long_options.include?('test')
ENV['APP_ENV'] = 'production' unless ENV.key?('APP_ENV')

App.instance
App::run port: port