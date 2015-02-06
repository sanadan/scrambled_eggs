# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrambled_eggs/version'

Gem::Specification.new do |spec|
  spec.name          = "scrambled_eggs"
  spec.version       = ScrambledEggs::VERSION
  spec.authors       = ["sanadan"]
  spec.email         = ["jecy00@gmail.com"]
  spec.summary       = %q{Easy data scrambler.}
  spec.description   = %q{Easy data Scrambler. Default by hostname.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency 'test-unit'

  spec.required_ruby_version = '>= 2.0.0'
end
