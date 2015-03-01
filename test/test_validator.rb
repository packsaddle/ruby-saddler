require_relative 'helper'

module Saddler
  class TestValidator < Test::Unit::TestCase
    sub_test_case '.valid?' do
      valid_xml = "<?xml version='1.0'?><foo></foo>"
      invalid_xml = 'INVALID!!<>'
      actual_xml = File.read('./test/fixtures/one_example.xml')
      test 'valid xml' do
        assert_nothing_raised do
          Validator.valid?(valid_xml)
        end
      end
      test 'invalid xml' do
        assert_raise(InvalidXMLError) do
          Validator.valid?(invalid_xml)
        end
      end
      test 'actual xml' do
        assert_nothing_raised do
          Validator.valid?(actual_xml)
        end
      end
    end
  end
end
