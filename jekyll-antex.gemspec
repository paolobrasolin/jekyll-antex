# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
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
  spec.homepage      = 'https://github.com/paolobrasolin/jekyll-antex'

  spec.files         = `git ls-files lib README.md LICENSE.txt`.split("\n")
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3', '< 3.1'

  spec.add_runtime_dependency 'antex', '~> 0.1.3'
  spec.add_runtime_dependency 'jekyll', ['>= 3', '< 5']
  spec.add_runtime_dependency 'kramdown-parser-gfm', '~> 1.1.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1'
end
