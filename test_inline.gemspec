Gem::Specification.new do |s|
  s.name = 'test_inline'
  s.version = '0.4.2'
  s.homepage = 'http://wiki.github.com/eric1234/test_inline/'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rake'
  s.files = Dir['lib/**/*']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Place your automated testing right next to the code being tested'
  s.description = <<-DESCRIPTION
    test_inline allows you to place your automated testing right next
    to the code being tested much like RDoc allows you to put your
    documentation right next to the code being documented. See the
    README for the rational for why you would want to do this.
  DESCRIPTION
end
