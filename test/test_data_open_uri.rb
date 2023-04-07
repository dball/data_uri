# frozen_string_literal: true

# rubocop:disable Security/Open

require_relative './test_helper'
require 'open-uri'

describe URI::Data do
  describe 'a valid data URI' do
    before do
      @base64 = 'R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=='
      @uri = URI.parse("data:image/gif;base64,#{@base64}")
      @data = Base64.decode64(@base64)
    end

    it 'should open' do
      _(@uri.open.read).must_equal @data
    end

    it 'should open with a block' do
      @uri.open do |io|
        _(io.read).must_equal @data
      end
    end

    it 'should have content_type on opened IO' do
      _(@uri.open.content_type).must_equal 'image/gif'
    end

    if RUBY_VERSION.to_i < 3 # no longer allowed in ruby 3+
      it 'should open on Kernel.open' do
        _(open(@uri).read).must_equal @uri.data
      end
    end

    it 'should open on URI.open' do
      _(URI.open(@uri).read).must_equal @uri.data
    end
  end
end
