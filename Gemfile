source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'
gem 'rails', '~> 5.1.6'
gem 'i18n', '~> 1.0', '>= 1.0.1'
gem 'faraday', '~> 0.14.0'
gem 'webmock', '~> 3.3'
gem 'bcrypt', '3.1.11'
gem 'puma', '~> 3.7'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jsonapi-resources'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'sass-rails', '~> 5.0', '>= 5.0.7'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec', '~> 3.0'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
  gem 'debase', '~> 0.2.2'
  gem 'ruby-debug-ide', '~> 0.6.1'
  gem 'factory_bot_rails'
  gem 'faker', '1.8.7'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.55.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "better_errors"
  gem "binding_of_caller"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
