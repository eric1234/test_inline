class Test::Inline::Railtie < Rails::Railtie

  # The paths considered part of the "unit" tests.
  cattr_accessor :unit_paths
  self.unit_paths = %w(app/models app/helpers lib)

  # The paths considered part of the "functional" tests
  cattr_accessor :functional_paths
  self.functional_paths = %w(app/controllers)

  initializer 'test_inline.configure' do
    Rails.backtrace_cleaner.remove_silencers! if Rails.env.test?
  end

  # Anything else uses ActiveSupport::TestCase
  initializer 'test_inline.register.activesupport_testcase' do
    Test::Inline.register_abstract_test_case /./, 'ActiveSupport::TestCase'
  end

  # Anything under app/models should use ActiveRecord::TestCase
  initializer 'test_inline.register.activerecord_testcase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/models').to_s)),
      'ActiveRecord::TestCase' if defined? ActiveRecord
  end

  # Anything under app/controllers should use ActionController::TestCase
  # Since the TestCase has no name we need to configure controller_class
  initializer 'test_inline.register.actioncontroller_testCase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/controllers').to_s)),
      'ActionController::TestCase' do |klass, path|
      zap = Regexp.escape Rails.root.join('app/controllers').to_s
      path = path.sub Regexp.new('^' + zap), ''
      path = path.sub(/\.rb$/, '')
      klass.controller_class = path.camelize.constantize
    end
  end

  # Anything under app/helpers should use ActionView::TestCase
  # Since the TestCase has no name we need to configure helper_class
  initializer 'test_inline.register.actionview_testcase' do
    Test::Inline.register_abstract_test_case \
      Regexp.new(Regexp.escape(Rails.root.join('app/helpers').to_s)),
      'ActionView::TestCase' do |klass, path|
      zap = Regexp.escape Rails.root.join('app/helpers').to_s
      path = path.sub Regexp.new('^' + zap), ''
      path = path.sub(/\.rb/, '')
      klass.helper_class = path.camelize.constantize
    end
  end

  # We provide tasks for running unit and functional tests (or both)
  rake_tasks do
    load "test_inline/tasks/test_inline.rake"
  end
end
