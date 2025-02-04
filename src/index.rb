# frozen_string_literal: true
require 'dotenv/load'
require 'argv'
require_relative 'app'

port = 8088

ARGV.each_with_index do |arg, index|
  port = ARGV[index + 1].to_i if arg == '-p' && ARGV[index + 1]
end

App.instance
App::run port: port