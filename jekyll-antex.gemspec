# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/antex/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-antex'
  spec.version       = Jekyll::Antex::VERSION
  spec.license       = 'MIT'

  spec.summary       = 'Universal TeX integration for Jekyll'
  spec.description   = <<~DESCRIPTION.gsub(/\s+/, ' ')
    Jekyll-anTeX implements universal TeX support in Jekyll
    to embed and render arbitrary code using any engine and dialect.
  DESCRIPTION

  spec.author        = 'Paolo Brasolin'
  spec.email         = 'paolo.brasolin@gmail.com'
  spec.homepage      = 'https://github.com/paolobrasolin/antex'

  spec.files         = `git ls-files lib README.md LICENSE.txt`.split("\x0")
  spec.require_paths = ['lib']

  # spec.required_ruby_version = '~> 2.4'

  spec.add_runtime_dependency 'jekyll', '~> 3.0'
  # spec.add_runtime_dependency 'antex'

  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  # spec.add_development_dependency 'cucumber'
end
