if Object.const_defined?('Test')
  Test::Inline.register_abstract_test_case \
    Regexp.new(Regexp.escape(Rails.root.join('app/models'))),
    ActiveRecord::TestCase
  Test::Inline.register_abstract_test_case \
    Regexp.new(Regexp.escape(Rails.root.join('app/controllers'))),
    ActionController::TestCase do |klass, path|
    zap = Regexp.escape Rails.root.join('app/controllers')
    path = path.sub Regexp.new('^' + zap), ''
    path = path.sub(/\.rb$/, '')
    klass.controller_class = path.camelize.constantize
  end
  require 'action_view/test_case'
  Test::Inline.register_abstract_test_case \
    Regexp.new(Regexp.escape(Rails.root.join('app/helpers'))),
    ActionView::TestCase do |klass, path|
    zap = Regexp.escape Rails.root.join('app/helpers')
    path = path.sub Regexp.new('^' + zap), ''
    path = path.sub(/\.rb/, '')
    klass.helper_class = path.camelize.constantize
  end
  Test::Inline.register_abstract_test_case \
    Regexp.new(Regexp.escape(Rails.root.join('lib'))),
    ActiveSupport::TestCase
end