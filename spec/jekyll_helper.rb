# frozen_string_literal: true

require 'tmpdir'
require 'jekyll'
Jekyll.logger.log_level = :error

def setup_tmpdir(method_name = :tmpdir)
  let(method_name) { File.join Dir.tmpdir, 'jekyll-antex_tests' }

  before(:each) do
    FileUtils.rm_rf method(method_name).call
    FileUtils.mkdir_p method(method_name).call
  end

  after(:each) do
    FileUtils.rm_rf method(method_name).call
  end
end

def setup_site(configuration = {}, method_name = :site)
  let(method_name) do
    defaults = {
      source: tmpdir,
      destination: File.join(tmpdir, '_site')
    }
    site_config = Jekyll.configuration defaults.merge(configuration)
    site = Jekyll::Site.new site_config
    site
  end
end

def setup_config(content = '')
  before do
    File.open(File.join(tmpdir, '_config.yml'), 'w') do |file|
      file.write content
    end
  end
end

def setup_page(content = '', method_name = :page)
  before do
    File.open(File.join(tmpdir, "#{method_name}.md"), 'w') do |file|
      file.write content
    end
  end

  let(method_name) do
    File.read File.join(tmpdir, '_site', "#{method_name}.html")
  end
end

def setup_post(content = '', method_name = :post)
  before do
    FileUtils.mkdir_p File.join(tmpdir, '_posts')
    filename = File.join(tmpdir, '_posts', "1970-01-01-#{method_name}.md")
    File.open(filename, 'w') { |file| file.write content }
  end

  let(method_name) do
    File.read File.join(tmpdir, '_posts', "1970-01-01-#{method_name}.html")
  end
end
