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
    option :repo
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

      pass_options = {}
      pass_options[:repo] = options[:repo] if options[:repo]

      require options[:require] if options[:require]
      if(options[:reporter])
        reporter = ::Saddler::Reporter.new.add_reporter(options[:reporter], $stdout)
      end

      abort('no reporter') unless reporter
      reporter.report(data, pass_options)
    end
  end
end
