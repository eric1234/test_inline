require 'test_inline/core_ext'

module Test
  module Inline
    PROCESSED = []

    # Will registar parent classes for the TestCase subclasses that
    # will be created. This is useful to provide default behavior of
    # a test case such as setup, teardown or private methods across
    # a general class of files. This is used heavily for the Rails
    # integration.
    def self.register_abstract_test_case(path_regexp, klass, &callback)
      @abstract_test_cases ||= []
      @abstract_test_cases.unshift({
        :path_regexp => path_regexp,
        :klass => klass,
        :callback => callback || proc {|x, y|}
      })
    end

    # Will initialize inline tests located on files in the given paths
    # and run them in the Test::Unit environment.
    def self.setup *paths
      @paths ||= []
      @paths += paths

      # First setup should init Test::Unit and default parent class
      if @abstract_test_cases.nil?
        require 'test/unit'
        register_abstract_test_case /./, Test::Unit::TestCase
      end
    end

    # Will get the TestCase for the given path
    def self.test_case_for(path)
      @test_cases ||= {}
      path = File.expand_path path
      return @test_cases[path] if @test_cases.has_key? path
      config = @abstract_test_cases.find {|c| path =~ c[:path_regexp]}
      klass = Class.new config[:klass]
      config[:callback].call klass, path
      @test_cases[path] = klass
    end

    # Will return the paths that are setup for testing
    def self.paths; @paths end

    # Will reset remove all tests already setup.
    def self.reset # :nodoc:
      @paths = nil
      @abstract_test_cases = nil
      @test_cases = nil
    end
  end
end

module Kernel

  # Will add the test to the list of tests run run. Will run the tests
  # automatically if file with inline tests is simply run.
  def Test name=String.rand(5), &blk
    path, line = *calling_code
    modify_inline_test_case path, line do |tc|
      file = File.basename(path).gsub /\W+/, '_'
      name = "test_#{name.gsub /\W+/, '_'}_#{file}_#{line}_00000" unless name =~ /\d{5}$/
      name = name.succ while tc.instance_methods.include? name.to_sym
      tc.send :define_method, name, &blk
    end
  end

  def ForTest &blk
    modify_inline_test_case(*calling_code) {|tc| tc.class_eval &blk}
  end

  private

  def modify_inline_test_case path, line, &blk
    path = File.expand_path path
    Test::Inline.setup path if
      Test::Inline.paths.nil? && (File.expand_path($0) == path)
    if Test::Inline.paths
      return if Test::Inline::PROCESSED.include? "#{path}:#{line}"
      Test::Inline::PROCESSED << "#{path}:#{line}"
      if Test::Inline.paths.any? {|p| path.starts_with? File.expand_path(p)}
        tc = Test::Inline.test_case_for path
        blk.call tc
      end
    end
  end
end

require 'test_inline/rails_integration' if defined? Rails::Railtie
