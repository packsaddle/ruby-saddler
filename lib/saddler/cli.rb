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
    option :data
    option :file
    option :options, type: :hash, default: {}
    option :require
    option :reporter
    def report
      data = \
          if options[:data]
            options[:data]
          elsif options[:file]
            File.read(options[:file])
          elsif !$stdin.tty?
            ARGV.clear
            ARGF.read
          end

      abort('no input') if !data || data.empty?

      require options[:require] if options[:require]
      if options[:reporter]
        reporter = ::Saddler::Reporter.add_reporter(options[:reporter], $stdout)
      end

      abort('no reporter') unless reporter
      reporter.report(data, options[:options])
    end
  end
end
