# This file contains logic that enhances core Ruby functionality but
# not anything that is specifically related to test_inline. Just stuff
# to make Ruby more expressive.

# ActiveSupport includes a number of goodies we use. Most people have
# it due to the proliferation of Rails so rather than duplicating the
# functionality we will just add the dependency.
require 'rubygems'
require 'active_support'
require 'active_support/core_ext/string/starts_ends_with'
require 'active_support/core_ext/array/random_access'
require 'active_support/core_ext/string/inflections'

module Kernel
  # Will return the calling file and line number as an array
  def calling_code
    begin
      raise StandardError
    rescue
      $!.backtrace[2].split(':', 3)[0..1]
    end
  end
end

class Array

  # In case running under ActiveSupport 2.3.x
  #
  # Our def seems to be slightly different than the one from Ruby.
  # Ruby doesn't repeat the same letter. I actually prefer ours but
  # for the purpose of this library either will work so if sample
  # exists then I will defer to that implementation.
  def sample(n=nil)
    (0...(n || 1)).inject([]) {|m, i| m << random_element}
  end unless method_defined? :sample

  # In case running under ActiveSupport < 2.3.8
  alias_method :random_element, :rand unless method_defined? :random_element

end

class String
  class << self
    # Returns a random string of length characters using the given
    # characterset (default to alphanumeric)
    def rand length, characters=String.alpha_numeric_charset
      characters.to_a.sample(length).join
    end

    # Returns an array of all alphanumeric characters
    def alpha_numeric_charset
      ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    end
  end
end
