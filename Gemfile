source "https://rubygems.org"

# Manage Jekyll version for consistent builds
gem "jekyll", "~> 4.3.3"
gem "jekyll-sass-converter", "~> 2.2.0"

# Default theme for Jekyll sites, customizable
gem "minima", github: "jekyll/minima"

# Plugin group for Jekyll enhancements
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17.0"
  gem "jekyll-sitemap", "~> 1.4.0"
  gem "yt", "~> 0.32.5"
  gem "asciidoctor", "~> 1.5", ">= 1.5.4"
end

# Timezone data for compatibility across environments
install_if -> { RUBY_PLATFORM =~ /mingw|mswin|java/ } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Enhance directory watching on Windows
gem "wdm", "~> 0.1.1", install_if: Gem.win_platform?
gem "webrick" # Required for Ruby 3.0 and above
