# frozen_string_literal: true
require 'webmock/rspec'
require 'json'
require 'pry-byebug'
require 'faraday'
require 'active_support/all'
require 'simplecov'

SimpleCov.start

PROJECT_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(PROJECT_ROOT, 'lib', '*.rb')).each do |file|
 autoload File.basename(file, '.rb').camelize, file
end

RSpec.configure do |config|
end