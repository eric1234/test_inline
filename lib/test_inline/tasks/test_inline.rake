# Some rake tasks for Rails integration
namespace :test do
  namespace :inline do

    desc "Run inline tests in app/models, app/helpers and lib"
    task :units do
      fork do
        test_environment
        paths = %w(app/models app/helpers lib).collect {|p| Rails.root.join p}
        Test::Inline.setup *paths
        paths.each do |p|
          Dir["#{p}/**/*.rb"].each do |f|
            require File.expand_path(f)
          end
        end
      end
      Process.wait
    end

    desc "Run inline tests in app/controllers"
    task :functionals do
      fork do
        test_environment
        path = Rails.root.join('app/controllers')
        Test::Inline.setup path
        Dir["#{path}/**/*.rb"].each do |f|
          require File.expand_path(f)
        end
      end
      Process.wait
    end

  end
  task :inline => ['test:inline:units', 'test:inline:functionals']

  private

  # Rails has already loaded in order to find these Rake tasks in the
  # gem. Likely in development mode. We want to avoid people having
  # to set the environment manually. So we do some hacks to try to
  # switch to test mode. Currently we are still logging to the
  # development log. Also likely the development initializer was loaded.
  # FIXME: There must be a better way to do this!
  def test_environment
    Rails.env = 'test'
    ActionMailer::Base.delivery_method = :test
    require Rails.root.join('test/test_helper')
  end
end
