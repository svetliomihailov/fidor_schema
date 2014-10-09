# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fidor_acl_version'

Gem::Specification.new do |spec|
  spec.name          = 'fidor_acl'
  spec.version       = Fidor::Acl::VERSION
  spec.authors       = ['Georg Leciejewski']
  spec.email         = ['dev@fidortecs.de']
  spec.summary       = %q{Permissions for Fidor oAuth clients}
  spec.description   = %q{This gem keeps our permissions/scopes for oAuth apps and api clients. It further provides helper methods for Ruby apps to show and check permissions.}
  spec.homepage      = 'http://www.fidortecs.de'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'i18n'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'json_schema_tools'
  spec.add_development_dependency 'activemodel' # required by above
  spec.add_development_dependency 'fidor_schema'
end
