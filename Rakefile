require 'rake/testtask'
require 'rake/gempackagetask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
end
task :default => :test

spec = eval File.read('test_inline.gemspec')
Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = false
end

desc "Publish gem to rubygems.org"
task :publish => :package do
  `gem push pkg/#{spec.name}-#{spec.version}.gem`
end