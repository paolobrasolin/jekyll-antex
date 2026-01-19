# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development, :ci do
  gem 'rspec', '~> 3.13'
  gem 'simplecov', '~> 0.22'
end

group :development do
  gem 'byebug', '~> 13.0' if RUBY_VERSION >= '3.2'
  gem 'guard', '~> 2.20'
  gem 'guard-rspec', '~> 4.7'
  gem 'reek', '~> 6.5' if RUBY_VERSION >= '3.1'
  gem 'rubocop', '~> 1.82' if RUBY_VERSION >= '2.7'
  gem 'yard', '~> 0.9'
end
