# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fidor/version'

Gem::Specification.new do |spec|
  spec.name          = 'fidor'
  spec.version       = Fidor::Acl::VERSION
  spec.authors       = ['Georg Leciejewski']
  spec.email         = ['dev@fidortecs.de']
  spec.summary       = %q{Permissions for Fidor oAuth clients}
  spec.description   = %q{This gem keeps our permissions/scopes for oAuth apps and api clients. It further provides helper methods for Ruby apps to show and check permissions.}
  spec.homepage      = ""
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activesupport'
end
