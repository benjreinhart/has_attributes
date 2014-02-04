# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_attributes/version'

Gem::Specification.new do |spec|
  spec.name          = "has_attributes"
  spec.version       = HasAttributes::VERSION
  spec.authors       = ["Ben Reinhart"]
  spec.email         = ["benjreinhart@gmail.com"]
  spec.summary       = %q{Better plain-ruby models}
  spec.description   = %q{Extend your classes with simple methods for creating elegant plain-ruby models}
  spec.homepage      = "https://github.com/benjreinhart/has_attributes"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
