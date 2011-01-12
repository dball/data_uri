require 'data_uri'
require 'minitest/spec'
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

  describe "a text/html data URI with a charset" do
  
    before do
      @uri = URI.parse("data:text/html;charset=utf-8,%3C%21DOCTYPE%20html%3E%0D%0A%3Chtml%20lang%3D%22en%22%3E%0D%0A%3Chead%3E%3Ctitle%3EEmbedded%20Window%3C%2Ftitle%3E%3C%2Fhead%3E%0D%0A%3Cbody%3E%3Ch1%3E42%3C%2Fh1%3E%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A%0D%0A")
    end

    it "should parse as a URI::Data object" do
      @uri.class.must_equal URI::Data
    end

    it "should have a content_type of text/html" do
      @uri.content_type.must_equal 'text/html'
    end
    
    it "should have data" do
      @uri.data.must_equal "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head><title>Embedded Window</title></head>\r\n<body><h1>42</h1></body>\n</html>\n\r\n"
    end

  end

end
