require 'data_uri'
require 'minitest/autorun'

describe URI::Data do

  describe "a base64 encoded image/gif data URI" do
    
    before do
      @base64 = "R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=="
      @uri = URI.parse("data:image/gif;base64,#{@base64}")
    end

    it "should parse as a URI::Data object" do
      @uri.class.must_equal URI::Data
    end

    it "should have a content_type of image/gif" do
      @uri.content_type.must_equal 'image/gif'
    end

    it "should have data" do
      require 'base64'
      @uri.data.must_equal Base64.decode64(@base64)
    end

  end

  describe "a text/plain data URI" do

    before do
      @uri = URI.parse("data:,A%20brief%20note")
    end

    it "should parse as a URI::Data object" do
      @uri.class.must_equal URI::Data
    end

    it "should have a content_type of text/plain" do
      @uri.content_type.must_equal 'text/plain'
    end
    
    it "should have data" do
      @uri.data.must_equal 'A brief note'
    end

  end

end
