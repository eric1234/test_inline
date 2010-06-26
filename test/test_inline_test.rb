require 'test/unit'
require 'test_inline'

class TestInlineTest < Test::Unit::TestCase

  def setup
    Test::Inline.reset
  end

  # Verify we can call Test and it is a noop if we are not running tests
  def test_registration_noop
    Test {}
    assert_nil Test::Inline.paths
  end

  # Register a test with a custom parent and injected functionality
  def test_registration_with_parent
    Test::Inline.setup __FILE__
    parent = Class.new Test::Unit::TestCase
    parent.send(:define_method, :priv) {'baz'}
    Test::Inline.register_abstract_test_case /_test\.rb$/, parent do |klass, path|
      klass.send(:define_method, :another) {path}
    end
    Test('xyz') {priv}
    Test('abc') {cat}
    ForTest {def cat; 'dog' end}
    assert Test::Inline.test_case_for(__FILE__).instance_methods.include?("test_xyz00000")
    assert_equal 'baz', Test::Inline.test_case_for(__FILE__).new(:test_xyz00000).test_xyz00000
    assert Test::Inline.test_case_for(__FILE__).instance_methods.include?("test_abc00000")
    assert_equal 'dog', Test::Inline.test_case_for(__FILE__).new(:test_abc00000).test_abc00000
    assert_equal File.expand_path(__FILE__),
      Test::Inline.test_case_for(__FILE__).new(:another).another
  end

  # Make sure we can call setup multiple times and the paths add
  def test_setup
    Test::Inline.setup '/tmp', '/usr'
    assert_equal ['/tmp', '/usr'], Test::Inline.paths
    Test::Inline.setup '/etc'
    assert_equal ['/tmp', '/usr', '/etc'], Test::Inline.paths
  end

  # If we run the current file without doing setup make sure tests run
  def test_auto_build
    old_script = $0
    $0 = __FILE__
    Test('def') {'bar'}
    $0 = old_script
    assert Test::Inline.test_case_for(__FILE__).instance_methods.include?("test_def00000")
    assert_equal 'bar', Test::Inline.test_case_for(__FILE__).new(:test_def00000).test_def00000
  end

  # If we don't provide a name make sure it generates one
  def test_auto_name
    Test::Inline.setup __FILE__
    Test {'no name'}
    assert !Test::Inline.test_case_for(__FILE__).instance_methods.grep(/^test_/).empty?
  end

  def test_test_case_for
    Test::Inline.setup __FILE__
    a = Test::Inline.test_case_for '/a'
    b = Test::Inline.test_case_for '/b'
    c = Test::Inline.test_case_for '/a'
    assert_equal a.object_id, c.object_id
    assert_not_equal a.object_id, b.object_id
    assert_not_equal c.object_id, b.object_id
  end

end