module Saddler
  class Validator
    def self.valid?(data)
      REXML::Document.new(data)
      true
    rescue REXML::ParseException => e
      exception = InvalidXMLError.new(e.message)
      exception.set_backtrace(e.backtrace)
      raise exception
    end
  end
end
