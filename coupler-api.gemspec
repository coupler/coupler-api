# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coupler-api/version'

Gem::Specification.new do |spec|
  spec.name          = "coupler-api"
  spec.version       = CouplerAPI::VERSION
  spec.authors       = ["Jeremy Stephens"]
  spec.email         = ["jeremy.f.stephens@vanderbilt.edu"]

  spec.summary       = %q{Coupler web API, used for interacting with Linkage}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "linkage", "~> 0.1.0"
  spec.add_dependency "rack", "~> 1.6.0"
  spec.add_dependency "thor", "~> 0.19.0"
  spec.add_dependency "rack-cors", "~> 0.4.0"
  spec.add_dependency "hashery", "~> 2.1.1"
  spec.add_dependency "sequel"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test", "~> 0.6.3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"

  if RUBY_PLATFORM == "java"
    spec.add_dependency "jdbc-mysql", "~> 5.1.38"
    spec.add_dependency "jdbc-sqlite3", "~> 3.8.11.2"
  else
    spec.add_dependency "sqlite3", "~> 1.3.11"
    spec.add_dependency "mysql2", "~> 0.4.2"
  end
end
