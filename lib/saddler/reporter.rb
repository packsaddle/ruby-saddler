module Saddler
  module Reporter
    def self.add_reporter(reporter_type, output = nil)
      reporter = custom_reporter_class(reporter_type)
      output = $stdout unless output
      reporter.new(output)
    end

    # Copy from rubocop:
    # lib/rubocop/formatter/formatter_set.rb
    def self.custom_reporter_class(specified_class_name)
      constant_names = specified_class_name.split('::')
      constant_names.shift if constant_names.first.empty?
      constant_names.reduce(Object) do |namespace, constant_name|
        namespace.const_get(constant_name, false)
      end
    end
  end
end
