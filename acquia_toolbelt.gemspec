# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "acquia_toolbelt/version"

Gem::Specification.new do |spec|
  spec.name          = "acquia_toolbelt"
  spec.version       = AcquiaToolbelt::VERSION
  spec.authors       = ["Jacob Bednarz"]
  spec.email         = ["jacob.bednarz@gmail.com"]
  spec.description   = %q{A CLI tool for interacting with Acquia's hosting services.}
  spec.summary       = ""
  spec.homepage      = "https://github.com/jacobbednarz/acquia-toolbelt"
  spec.license       = "MIT"

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "0.18.1"
  spec.add_runtime_dependency "netrc", "0.7.7"
  spec.add_runtime_dependency "highline", "1.6.19"
  spec.add_runtime_dependency "faraday", "0.8.8"
  spec.add_runtime_dependency "json", "1.8.0"
  spec.add_runtime_dependency "rainbow", "1.1.4"
  spec.add_runtime_dependency "sshkey", "1.6.0"
  spec.add_runtime_dependency "multi_json", "1.8.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "10.1.0"
  spec.add_development_dependency "rspec", "2.14.1"
  spec.add_development_dependency "vcr", "2.7.0"
  spec.add_development_dependency "webmock", "1.15.2"
  spec.add_development_dependency "guard-rspec"
end
