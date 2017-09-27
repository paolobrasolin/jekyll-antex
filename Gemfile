# frozen_string_literal: true

source 'https://rubygems.org'

gemspec name: 'jekyll-antex'

group :development do
  gem 'rspec'
  gem 'simplecov'
  # gem 'rake'
  # gem 'cucumber'
  # gem 'guard'
  # gem 'guard-cucumber'
end

# TODO: drop this
if Dir.exist?(File.expand_path('~/antex'))
  gem 'antex', path: '~/antex'
elsif ENV['TRAVIS']
  gem 'antex', git: 'https://github.com/paolobrasolin/antex.git'
  # gem 'antex'
end
