namespace :test do
  namespace :inline do

    desc "Run inline tests in app/models, app/helpers and lib"
    task :units do
      RAILS_ENV = 'test'
      require 'test_inline'
      fork do
        paths = %w(app/models app/helpers lib).collect {|p| Rails.root.join p}
        Test::Inline.setup *paths
        require Rails.root.join('test/test_helper')
        paths.each do |p|
          Dir["#{p}/**/*.rb"].each do |f|
            require File.expand_path(f)
          end
        end
        Test::Unit::AutoRunner.run
      end
      Process.wait
    end

    desc "Run inline tests in app/controllers"
    task :functionals do
      RAILS_ENV = 'test'
      require 'test_inline'
      fork do
        path = Rails.root.join('app/controllers')
        Test::Inline.setup path
        require Rails.root.join('test/test_helper')
        Dir["#{path}/**/*.rb"].each do |f|
          require File.expand_path(f)
        end
        Test::Unit::AutoRunner.run
      end
      Process.wait
    end

  end
  task :inline => ['test:inline:units', 'test:inline:functionals']
end