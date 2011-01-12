module URI

  class Data < Generic

    COMPONENT = [:scheme, :opaque].freeze

    attr_reader :content_type, :data

    def initialize(*args)
      super(*args)
      @data = @opaque
      if md = MIME::Type::MEDIA_TYPE_RE.match(@data)
        offset = md.offset(0)
        if offset[0] == 0
          @content_type = md[0]
          @data = @data[offset[1] .. -1]
        end
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
