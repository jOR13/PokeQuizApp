# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.3.1'
gem 'bootsnap', require: false
gem 'httparty'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webmock'
end

gem 'dockerfile-rails', '>= 1.6', group: :development
gem 'redis', '~> 5.2'
