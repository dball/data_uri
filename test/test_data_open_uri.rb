require 'data_uri'
require 'open-uri'
require 'data_uri/open_uri'
require 'minitest/autorun'
require 'minitest/spec'

describe URI::Data do

  describe "a valid data URI" do

    before do
      @base64 = "R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=="
      @uri = URI.parse("data:image/gif;base64,#{@base64}")
      @data = Base64.decode64(@base64)
    end

    it "should open" do
      @uri.open.read.must_equal @data
    end

    it "should open with a block" do
      @uri.open do |io|
        io.read.must_equal @data
      end
    end

    it "should have content_type on opened IO" do
      @uri.open.content_type.must_equal 'image/gif'
    end

    it "should open on Kernel.open" do
      open(@uri).read.must_equal @uri.data
    end

  end

end
