# require 'test/unit'
require 'rspec'
require 'jekyll'
require 'jekyll/texyll'
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

  options = Jekyll.configuration(options)

  prepend_test_dir(options, 'source')
  prepend_test_dir(options, 'destination')

  print options['source'] + "\n"
  print options['destination'] + "\n"
  site = Jekyll::Site.new(options)
  site.process

  puts "DONE"

end


# Enable using plain MiniTest assertions instead of quasi-english shoulda
# require 'test/unit/assertions'
# World Test::Unit::Assertions

