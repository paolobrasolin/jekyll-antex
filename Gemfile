# frozen_string_literal: true

source 'https://rubygems.org'

gemspec name: 'jekyll-antex'

group :development do
  # gem 'rake'
  gem 'cucumber'
  gem 'rspec'
  gem 'simplecov'
  # gem 'guard'
  # gem 'guard-cucumber'
end

# TODO: drop this
if Dir.exist?(File.expand_path('~/antex'))
  gem 'antex', path: '~/antex'
elsif ENV['TRAVIS']
  gem 'antex', git: 'https://github.com/paolobrasolin/antex.git'
else
  gem 'antex'
end
