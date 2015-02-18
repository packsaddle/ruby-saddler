require 'minitest_helper'

class TestSaddler < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Saddler::VERSION
  end
end
