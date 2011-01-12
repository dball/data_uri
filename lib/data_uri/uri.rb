module URI

  class Data < Generic

    COMPONENT = [:scheme, :opaque].freeze
    MIME_TYPE_RE = %r{^([-\w.+]+/[-\w.+]*)}.freeze

    attr_reader :content_type, :data

    def initialize(*args)
      super(*args)
      @data = @opaque
      if MIME_TYPE_RE.match(@data)
        @content_type = $1
        @data = @data[@content_type.length .. -1]
      end
      @content_type ||= 'text/plain'
      if base64 = /^;base64/.match(@data)
        @data = @data[7 .. -1]
      end
      unless /^,/.match(@data)
        raise 'Invalid data URI'
      end
      @data = @data[1 .. -1]
      @data = base64 ? Base64.decode64(@data) : URI.decode(@data)
    end
  end

  @@schemes['DATA'] = Data

end
