source "https://rubygems.org"

ruby RUBY_VERSION

gem "jekyll", "3.2.1"
#gem "execjs"
#gem "nokogiri"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
  if Dir.exist?(File.expand_path("~/texyll/master"))
    gem "jekyll-texyll", :path => "~/texyll/master"
  elsif ENV['TRAVIS']
    gem 'jekyll-texyll', :git => 'https://github.com/paolobrasolin/texyll.git'
  else
    gem 'jekyll-texyll'
  end
end
