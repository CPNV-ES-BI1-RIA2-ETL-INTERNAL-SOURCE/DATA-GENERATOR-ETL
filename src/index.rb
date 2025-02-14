# frozen_string_literal: true

require_relative 'app'

# TODO NGY - regarding the readme file, port number comes from argument command line (run server)
# Is it a "default" value in "case of" ?
port = 8088

ARGV.each_with_index do |arg, index|
  port = ARGV[index + 1].to_i if arg == '-p' && ARGV[index + 1]
end

App.instance
App::run port: port