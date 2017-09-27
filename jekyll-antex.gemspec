# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/antex/version'

Gem::Specification.new do |s|
  s.name          = 'jekyll-antex'
  s.version       = Jekyll::Antex::VERSION
  s.license       = 'MIT'

  s.summary       = 'Universal TeX integration for Jekyll'
  s.description   = <<~DESCRIPTION.gsub(/\s+/, ' ')
    Jekyll-anTeX implements universal TeX support in Jekyll
    to easily embed and render arbitrary code
    using any engine and dialect.
  DESCRIPTION

  s.author        = 'Paolo Brasolin'
  s.email         = 'paolo.brasolin@gmail.com'
  s.homepage      = 'https://github.com/paolobrasolin/antex'

  all_files       = `git ls-files -z`.split("\x0")
  # TODO: the following grep must be revised
  s.files         = all_files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency('jekyll', '~> 3.0')
  # s.add_runtime_dependency('antex')
  s.add_runtime_dependency('execjs')
  s.add_runtime_dependency('digest')
  s.add_runtime_dependency('nokogiri')

  # s.add_development_dependency('rake', '~> 11.0')
  s.add_development_dependency('rspec', '~> 3.5')
  s.add_development_dependency('rubocop', '~> 0.41')
  s.add_development_dependency('cucumber', '~> 2.1')
  s.add_development_dependency('yard')
end
