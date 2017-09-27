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

  # TODO: the following grep must be revised
  spec.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'jekyll', '~> 3.0'
  # spec.add_runtime_dependency 'antex'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'yard'
end
