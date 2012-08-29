require 'test/unit'
require 'test_inline/core_ext'

class KernerlTest < Test::Unit::TestCase
  def test_calling_code
    file, line = *foo
    assert_match /core_ext_test\.rb$/, file
    assert_equal '6', line
  end

  private
  def foo; calling_code end
end
