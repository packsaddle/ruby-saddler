require_relative 'helper'

module Saddler
  class TestSaddler < Test::Unit::TestCase
    test 'version' do
      assert do
        !::Saddler::VERSION.nil?
      end
    end
  end
end
