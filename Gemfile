# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# TODO: drop everything below this point

if Dir.exist?(File.expand_path('~/antex'))
  antex_source = { path: '~/antex' }
elsif ENV['TRAVIS']
  antex_source = { git: 'https://github.com/paolobrasolin/antex.git' }
end

gem 'antex', **antex_source
