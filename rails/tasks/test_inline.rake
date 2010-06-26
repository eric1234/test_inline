namespace :test do
  namespace :inline do

    desc "Run inline tests in app/models, app/helpers and lib"
    task :units => 'db:test:prepare' do
      fork do
        require Rails.root.join('test/test_helper')
        paths = %w(app/models app/helpers lib).collect {|p| Rails.root.join p}
        Test::Inline.setup *paths
        paths.each {|p| Dir["#{p}/**/*.rb"].each {|f| require f}}
        Test::Unit::AutoRunner.run
      end
      Process.wait
    end

    desc "Run inline tests in app/controllers"
    task :functionals => 'db:test:prepare' do
      fork do
        require Rails.root.join('test/test_helper')
        path = Rails.root.join('app/controllers')
        Test::Inline.setup path
        Dir["#{path}/**/*.rb"].each {|f| require f}
        Test::Unit::AutoRunner.run
      end
      Process.wait
    end

  end
  task :inline => ['test:inline:units', 'test:inline:functionals']
end