# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/(.+)_helper.rb$}) { 'spec' }
  watch(%r{^spec/(.+)_spec.rb$})
  watch(%r{^lib/(.+).rb$}) do |match|
    "spec/#{match[1]}_spec.rb"
  end
end
