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

      data = fetch_data(options)
      Validator.valid?(data)
      require options[:require] if options[:require]
      reporter = add_reporter(options)

      reporter.report(data, options[:options])
    rescue StandardError => e
      logger.error('options')
      logger.error(options)
      logger.error('input data')
      logger.error(data)
      logger.error('reporter')
      logger.error(reporter)
      raise e
    end

    no_commands do
      def logger
        ::Saddler.logger
      end

      def fetch_data(options)
        data = \
          if options[:data]
            options[:data]
          elsif options[:file]
            File.read(options[:file])
          elsif !$stdin.tty?
            ARGV.clear
            ARGF.read
          end

        logger.info('input data')
        logger.info(data)
        fail NoInputError if !data || data.empty?

        data
      end

      def add_reporter(options)
        reporter = Reporter.add_reporter(options[:reporter], $stdout) if options[:reporter]
        fail NoReporterError unless reporter
        logger.info('use reporter')
        logger.info(reporter)
        reporter
      end
    end
  end
end
