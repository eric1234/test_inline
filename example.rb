# An example of a simple class that uses inline testing

$LOAD_PATH << 'lib'
require 'test_inline'

class Version
  attr_reader :major, :minor, :patch_level

  # New Version object with given major, minor and patch_level versions.
  def initialize(major, minor, patch_level)
    @major, @minor, @patch_level =
      major.to_i, minor.to_i, patch_level.to_i
  end
  Test do
    v = Version.new 0, 1, 2
    assert_equal 0, v.major
    assert_equal 1, v.minor
    assert_equal 2, v.patch_level
  end

  # Will allow you to treat a Version as a String
  def to_str
    [major, minor, patch_level] * '.'
  end
  alias_method :to_s, :to_str
  Test do
    assert_equal '0.1.2', Version.new(0, 1, 2).to_str
    assert_equal '0.1.2', Version.new(0, 1, 2).to_s
  end

  # Compare two version numbers.
  # Mixes in Comparable to make all operators work
  def <=>(other)
    raise ArgumentError, 'Must be a Version object' unless other.is_a? Version
    to_str <=> other.to_str
  end
  include Comparable
  Test do
    v1 = Version.new 1, 2, 3
    v2 = Version.new 3, 1, 4

    assert_equal -1, (v1 <=> v2)
    assert_equal 1,  (v2 <=> v1)
    assert_equal 0,  (v1 <=> v1)

    assert (v1 < v2)
    assert (v2 > v1)
    assert (v1 == v1)
    assert v2.between?(v1, Version.new(9,4,3))

    assert_raises(ArgumentError) {v1 <=> '1.2.3'}
  end

  # Will take a version string, parse it and return a Version object
  def self.parse(str)
    raise ArgumentError, 'Invalid version format' if str !~ /^\d+\.\d+\.\d+$/
    new *str.split('.')
  end
  Test do
    v = Version.parse '0.1.2'
    assert_equal 0, v.major
    assert_equal 1, v.minor
    assert_equal 2, v.patch_level

    assert_raises(ArgumentError) {Version.parse '0.1.2a'}
  end

end