# frozen_string_literal: true
require 'webmock/rspec'
require 'json'
require 'pry-byebug'
require 'faraday'
require 'active_support/all'
require 'simplecov'
require 'simplecov_small_badge'

# SimpleCov.start

# Wherever your SimpleCov.start block is (spec_helper.rb, test_helper.rb, or .simplecov)
SimpleCov.start do
  # add your normal SimpleCov configs
  add_filter "/app/model"
  # call SimpleCov::Formatter::BadgeFormatter after the normal HTMLFormatter
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCovSmallBadge::Formatter
  ])
end

# configure any options you want for SimpleCov::Formatter::BadgeFormatter
SimpleCovSmallBadge.configure do |config|
  # does not created rounded borders
  config.rounded_border = true
  # set the background for the title to darkgrey
  config.background = '#ffffcc'
end

PROJECT_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(PROJECT_ROOT, 'lib', '*.rb')).each do |file|
 autoload File.basename(file, '.rb').camelize, file
end

RSpec.configure do |config|
end