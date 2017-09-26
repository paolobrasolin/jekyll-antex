# frozen_string_literal: true

require 'rspec'
require 'jekyll'
require 'jekyll/antex'
require 'tmpdir'

require 'nokogiri'

TEST_DIR = File.join(Dir.tmpdir, 'jekyll')

def prepend_test_dir(options, key)
  if options.key?(key)
    if Pathname(options[key]).relative?
      options[key] = File.join(TEST_DIR, options[key])
    end
  else
    options[key] ||= TEST_DIR
  end
end

def run_jekyll(options = {})
  @original_stderr = $stderr
  @original_stdout = $stdout
  $stderr = File.open(File::NULL, 'w')
  $stdout = File.open(File::NULL, 'w')
  options = Jekyll.configuration(options)
  $stderr = @original_stderr
  $stdout = @original_stdout

  prepend_test_dir(options, 'source')
  prepend_test_dir(options, 'destination')

  site = Jekyll::Site.new(options)
  site.process
end
