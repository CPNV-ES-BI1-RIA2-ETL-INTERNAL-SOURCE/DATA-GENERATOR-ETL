# frozen_string_literal: true

require 'logger'
require 'fileutils'

class MultiLogger

  def initialize(console_level: Logger::DEBUG, file_level: Logger::INFO, log_directory: './tmp/logs', log_file: 'logs.log')
    FileUtils.mkdir_p(log_directory) unless File.exist?(log_directory)
    @console_logger = Logger.new(STDOUT)
    @console_logger.level = console_level

    @file_logger = Logger.new(File.join(log_directory, log_file), 'daily')
    @file_logger.level = file_level
  end

  def log_to_console?(severity)
    severity >= @console_logger.level
  end

  def log_to_file?(severity)
    severity >= @file_logger.level
  end

  def log(severity, message)
    if log_to_console?(severity)
      @console_logger.add(severity) { message }
    end

    if log_to_file?(severity)
      @file_logger.add(severity) { message }
    end
  end

  def debug(message)
    log(Logger::DEBUG, message)
  end

  def info(message)
    log(Logger::INFO, message)
  end

  def warn(message)
    log(Logger::WARN, message)
  end

  def error(message)
    log(Logger::ERROR, message)
  end

  def fatal(message)
    log(Logger::FATAL, message)
  end
end