# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'fedex_trakpak'  
  s.version     = '1.0.4'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['zhang']
  s.email       = ['sdzc1014@163.com']
  s.homepage    = 'https://github.com/shangyukyo/fedex_trakpak.git'
  s.summary     = %q{Fedex Trakpak Web Services}
  s.description = ''

  s.rubyforge_project = 'fedex_trakpak'

  s.license = 'MIT'

  s.add_dependency 'httparty',            '>= 0.8.3'
  s.add_dependency 'nokogiri',            '>= 1.5.6'
  s.add_dependency 'roo',                 '>= 2.8.0'

  s.add_development_dependency "rspec",   '~> 3.0.0'
  s.add_development_dependency 'vcr',     '~> 2.0.0'
  s.add_development_dependency 'webmock', '~> 1.8.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
