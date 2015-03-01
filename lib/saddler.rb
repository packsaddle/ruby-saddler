require 'logger'
require 'saddler/version'
require 'saddler/reporter'
require 'saddler/error'

module Saddler
  def self.default_logger
    logger = Logger.new(STDERR)
    logger.progname = 'Saddler'
    logger.level = Logger::WARN
    logger
  end

  def self.logger
    return @logger if @logger
    @logger = default_logger
  end

  class << self
    attr_writer :logger
  end
end
