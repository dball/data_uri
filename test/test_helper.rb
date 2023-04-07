# frozen_string_literal: true

if RUBY_ENGINE != "truffleruby"
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
require 'minitest/spec'

require 'data_uri'
require 'data_uri/open_uri'
