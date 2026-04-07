# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.3'

gem 'blueprinter', '~> 0.25.3'
gem 'bootsnap', require: false
gem 'bunny', '~> 2.22'
gem 'dotenv-rails'
gem 'enumerize'
gem 'jwt'
gem 'mysql2', '~> 0.5'
gem 'oj'
gem 'puma', '>= 5.0'
gem 'rack-cors', '1.0.6', require: 'rack/cors'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'sentry-rails', '~> 5.5'

group :rubocop do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'autoload-checker', '~> 0.1'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'simplecov', '0.22', require: false
  gem 'timecop', require: false
end
