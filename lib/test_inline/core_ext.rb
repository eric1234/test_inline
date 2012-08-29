# This file contains logic that enhances core Ruby functionality but
# not anything that is specifically related to test_inline. Just stuff
# to make Ruby more expressive.

# ActiveSupport includes a number of goodies we use. Most people have
# it due to the proliferation of Rails so rather than duplicating the
# functionality we will just add the dependency.
require 'active_support'
require 'active_support/core_ext/string/starts_ends_with'
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
