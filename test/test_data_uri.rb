# frozen_string_literal: true

require_relative './test_helper'

describe URI::Data do
  describe 'parsing' do
    describe 'a base64 encoded image/gif data URI' do
      before do
        @base64 = 'R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=='
        @uri = URI.parse("data:image/gif;base64,#{@base64}")
      end

      it 'should parse as a URI::Data object' do
        _(@uri.class).must_equal URI::Data
      end

      it 'should have a content_type of image/gif' do
        _(@uri.content_type).must_equal 'image/gif'
      end

      it 'should have data' do
        require 'base64'
        _(@uri.data).must_equal Base64.decode64(@base64)
      end
    end

    describe 'a text/plain data URI' do
      before do
        @uri = URI.parse('data:,A%20brief%20note')
      end

      it 'should parse as a URI::Data object' do
        _(@uri.class).must_equal URI::Data
      end

      it 'should have a content_type of text/plain' do
        _(@uri.content_type).must_equal 'text/plain'
      end

      it 'should have data' do
        _(@uri.data).must_equal 'A brief note'
      end
    end

    describe 'a text/html data URI with a charset' do
      before do
        @uri = URI.parse('data:text/html;charset=utf-8,%3C%21DOCTYPE%20html%3E%0D%0A%3Chtml%20lang%3D%22en%22%3E%0D%0A%3Chead%3E%3Ctitle%3EEmbedded%20Window%3C%2Ftitle%3E%3C%2Fhead%3E%0D%0A%3Cbody%3E%3Ch1%3E42%3C%2Fh1%3E%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A%0D%0A')
      end

      it 'should parse as a URI::Data object' do
        _(@uri.class).must_equal URI::Data
      end

      it 'should have a content_type of text/html' do
        _(@uri.content_type).must_equal 'text/html'
      end

      it 'should have data' do
        _(@uri.data).must_equal "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head><title>Embedded Window</title></head>\r\n<body><h1>42</h1></body>\n</html>\n\r\n"
      end
    end

    describe 'a big data binary data URI' do
      before do
        @data = Array.new(100_000) { rand(256) }.pack('c*')
        @raw = "data:application/octet-stream;base64,#{Base64.encode64(@data).chop}"
      end

      it "isn't parsed by URI.parse" do
        if RUBY_VERSION == '1.8.7'
          uri = URI.parse(@raw)
          refute_equal uri.data, @data
        else
          _ { URI.parse(@raw) }.must_raise(URI::InvalidURIError)
        end
      end

      it 'should be parsed by URI::Data.new' do
        uri = URI::Data.new(@raw)
        assert_equal uri.data, @data
      end
    end

    describe 'an invalid data URI' do
      it 'should raise an error' do
        _ { URI::Data.new('This is not a data URI') }.must_raise(URI::InvalidURIError)
        _ { URI::Data.new('data:Neither this') }.must_raise(URI::InvalidURIError)
      end
    end
  end

  describe 'building' do
    before do
      @data = "GIF89a\001\000\001\000\200\000\000\377\377\377\000\000\000!\371\004\000\000\000\000\000,\000\000\000\000\001\000\001\000\000\002\002D\001\000;"
    end

    it 'given data and an explicit content_type' do
      uri = URI::Data.build(content_type: 'image/gif', data: StringIO.new(@data))
      _(uri.to_s).must_equal 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
    end

    it 'given data with an implicit content_type' do
      io = StringIO.new(@data)
      (class << io; self; end).instance_eval { attr_accessor :content_type }
      io.content_type = 'image/gif'
      uri = URI::Data.build(data: io)
      _(uri.to_s).must_equal 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
    end

    it 'given data and no content_type' do
      io = StringIO.new('foobar')
      uri = URI::Data.build(data: io)
      _(uri.to_s).must_equal 'data:;base64,Zm9vYmFy'
    end
  end
end
