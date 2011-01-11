require 'data_uri'
require 'minitest/autorun'

describe URI::Data do

  describe "a valid data URI" do
    
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

    it "should have decoded data" do
      require 'base64'
      @uri.data.must_equal Base64.decode64(@base64)
    end

  end

end
