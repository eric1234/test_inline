# Some rake tasks for Rails integration
namespace :test do
  namespace :inline do

    desc "Run inline tests in app/models, app/helpers and lib"
    task :units => :environment do
      if Rails.env.test?
        setup_and_run Test::Inline::Railtie.unit_paths
      else
        system "rake test:inline:units RAILS_ENV=test"
      end
    end

    desc "Run inline tests in app/controllers"
    task :functionals => :environment do
      if Rails.env.test?
        setup_and_run Test::Inline::Railtie.functional_paths
      else
        system "rake test:inline:functionals RAILS_ENV=test"
      end
    end

  end
  task :inline => ['test:inline:units', 'test:inline:functionals']

  private

  def setup_and_run(paths)
    require Rails.root.join('test/test_helper')
    paths.collect! {|p| Rails.root.join p}
    Test::Inline.setup *paths
    paths.each do |p|
      Dir["#{p}/**/*.rb"].each do |f|
        require File.expand_path(f)
      end
    end
  end
end
