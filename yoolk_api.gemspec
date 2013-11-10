# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yoolk_api/version'

Gem::Specification.new do |gem|
  gem.name          = "yoolk_api"
  gem.version       = YoolkApi::VERSION
  gem.authors       = ["chamnap", "vorleak"]
  gem.email         = ["chamnapchhorn@gmail.com", "vorleak.chy@gmail.com"]
  gem.description   = %q{A Ruby wrapper for the Yoolk REST API}
  gem.summary       = %q{A Ruby wrapper for the Yoolk REST API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", ">= 1.3.5"
  gem.add_development_dependency "rspec", "~> 2.14.1"
  gem.add_development_dependency "pry", "~> 0.9.12"
  gem.add_development_dependency "vcr", "~> 2.7.0"
  gem.add_development_dependency "webmock", "~> 1.15.2"
  gem.add_development_dependency "rake"

  gem.add_dependency "activesupport", ">= 3.2.12"
  gem.add_dependency "hashie", ">= 2.0.5"
  gem.add_dependency "typhoeus", "~> 0.6.6"
  gem.add_dependency "oj", "~> 2.1.7"
  gem.add_dependency "request_store", "~> 1.0.5"
end