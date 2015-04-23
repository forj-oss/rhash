# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subhash/version'

Gem::Specification.new do |spec|
  spec.name          = 'subhash'
  spec.version       = SubHash::VERSION
  spec.date          = SubHash::DATE
  spec.authors       = ['Christophe Larsonneur']
  spec.email         = ['clarsonneur@gmail.com']

  spec.summary       = 'Recursive Hash of hashes/Array management'
  spec.description   = 'Hash and Array object enhanced to manage Hash of Hash/Array easily.'
  spec.homepage      = "https://github.com/forj-oss/rhash"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rubocop", "~> 0.30.0"
end
