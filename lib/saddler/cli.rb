require 'thor'

module Saddler
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'version', 'Show the Saddler version'
    map %w(-v --version) => :version

    def version
      puts "Saddler version #{::Saddler::VERSION}"
    end

    desc 'report', 'Exec Report'
    def report
      puts 'done'
    end
  end
end
