# frozen_string_literal: true

require_relative 'app'

port = 8080

ARGV.each_with_index do |arg, index|
  port = ARGV[index + 1].to_i if arg == '-p' && ARGV[index + 1]
end

App::run port: port