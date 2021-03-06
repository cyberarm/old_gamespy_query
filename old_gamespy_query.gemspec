# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'old_gamespy_query/version'
Gem::Specification.new do |spec|
  spec.name = "old_gamespy_query"
  spec.version = OldGameSpyQuery::VERSION
  spec.authors = ["Cyberarm"]
  spec.email = ["matthewlikesrobots@gmail.com"]
  spec.summary = %q{Query old GameSpy servers.}
  spec.description = %q{Query old GameSpy servers.}
  spec.homepage = "https://github.com/cyberarm/old_gamespy_query"
  spec.license = "MIT"
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "gamespy_query"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
