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
    option :debug, type: :boolean, default: false
    option :verbose, type: :boolean, default: false
    def report
      if options[:debug]
        logger.level = Logger::DEBUG
      elsif options[:verbose]
        logger.level = Logger::INFO
      end
      logger.debug(options)

      data = \
          if options[:data]
            options[:data]
          elsif options[:file]
            File.read(options[:file])
          elsif !$stdin.tty?
            ARGV.clear
            ARGF.read
          end

      if !data || data.empty?
        logger.error('no input')
        abort
      end

      require options[:require] if options[:require]
      if options[:reporter]
        reporter = ::Saddler::Reporter.add_reporter(options[:reporter], $stdout)
      end

      unless reporter
        logger.error('no reporter')
        abort
      end

      begin
        reporter.report(data, options[:options])
      rescue StandardError => e
        logger.error(e.message)
        logger.error(e.backtrace)
      end
    end

    no_commands do
      def logger
        ::Saddler.logger
      end
    end
  end
end
