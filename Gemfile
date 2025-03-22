# frozen_string_literal: true

# TODO: NGY https://bundler.io/guides/using_bundler_in_applications.html#installing-gems---bundle-install

source 'https://rubygems.org'

# Ruby Version
ruby '~> 3.0'

# Core dependencies
gem 'argv'
gem 'bucket-sdk', git: 'https://github.com/drutz-cpnv/ria-bucket-sdk.git'
gem 'dotenv'
gem 'dry-auto_inject'
gem 'dry-container'
gem 'dry-monads'
gem 'dry-struct'
gem 'dry-validation'
gem 'httparty'
gem 'nokogiri'
gem 'ostruct'
gem 'ox'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rackup'
gem 'sinatra'

# Development dependencies
group :development do
  gem 'rubocop'
end

# Testing dependencies
group :test do
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'rack-test'
  gem 'rspec'
end
