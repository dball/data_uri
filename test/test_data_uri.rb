require 'data_uri'
require 'minitest/autorun'

describe URI::Data do

  describe "a valid data URI" do
    
    before do
      @base64 = "R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxsbP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0CcguWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7"
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
