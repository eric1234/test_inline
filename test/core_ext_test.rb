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

class StringTest < Test::Unit::TestCase
  def test_alpha_numeric_charset
    explicit = %w(
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    ) + [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    assert_equal explicit, String.alpha_numeric_charset
  end

  def test_rand
    assert_equal 5, String.rand(5).length
    assert_match /^\w+$/, String.rand(20)
    assert_match /^\d+$/, String.rand(20, 0..9)
  end
end
