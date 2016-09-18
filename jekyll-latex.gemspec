# coding: utf-8

# https://ayastreb.me/writing-a-jekyll-plugin/

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-latex/version'
Gem::Specification.new do |spec|
  spec.name          = 'jekyll-latex'
  spec.summary       = 'Jekyll LaTeX integration'
  spec.description   = 'LaTeX support in Jekyll'\
    ' to easily render and embed arbitrary code'
  spec.version       = Jekyll::Latex::VERSION
  spec.authors       = ['Paolo Brasolin']
  spec.email         = ['paolo.brasolin@gmail.com']
  spec.homepage      = 'https://github.com/paolobrasolin/jekyll-latex'
  spec.licenses      = ['MIT']
  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', '~> 3.0'

  spec.add_dependency 'execjs'
  spec.add_dependency 'digest'
  spec.add_dependency 'nokogiri'
  # spec.add_dependency 'fileutils'

  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.41'
end
