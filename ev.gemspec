# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'ev/version'

Gem::Specification.new do |s|
  s.name        = 'ev'
  s.version     = EV::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Matthew Conger-Eldeen']
  s.email       = ['mceldeen@gmail.com']
  s.homepage    = 'https://www.github.com/mceldeen/ev'
  s.licenses    = 'MIT'
  s.summary     = %q{A set of useful stuff for event sourcing.}
  s.description = %q{A set of useful stuff for event sourcing.}

  s.add_development_dependency 'rspec', '~>3.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end