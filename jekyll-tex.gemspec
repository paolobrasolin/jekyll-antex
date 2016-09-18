# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-tex/version'

Gem::Specification.new do |s|
  s.name          = 'jekyll-tex'
  s.version       = Jekyll::TeX::VERSION
  s.license       = 'MIT'

  s.summary       = 'Jekyll *TeX integration'
  s.description   = '*TeX support in Jekyll'\
    ' to easily render and embed arbitrary code'

  s.authors       = ['Paolo Brasolin']
  s.email         = 'paolo.brasolin@gmail.com'
  s.homepage      = 'https://github.com/paolobrasolin/jekyll-tex'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency('jekyll', '~> 3.0')
  s.add_runtime_dependency('execjs')
  s.add_runtime_dependency('digest')
  s.add_runtime_dependency('nokogiri')
  # s.add_runtime_dependency('fileutils')

  # s.add_development_dependency('rake', '~> 11.0')
  s.add_development_dependency('rspec', '~> 3.5')
  s.add_development_dependency('rubocop', '~> 0.41')
  s.add_development_dependency('cucumber', '~> 2.1')
end
