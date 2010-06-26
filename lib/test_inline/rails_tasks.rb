# Some glue to make it easy to include Rails-specific rake tasks in
# your Rails application. Simply put the following at the bottom of
# your Rakefile:
#
#   require 'test_inline'
#   require 'test_inline/rails_tasks'
glob = "#{Gem.searcher.find('test_inline').full_gem_path}/rails/tasks/*.rake"
Dir[glob].each {|ext| load ext}