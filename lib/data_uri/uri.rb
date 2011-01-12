module URI

  class Data < Generic

    COMPONENT = [:scheme, :opaque].freeze
    MIME_TYPE_RE = %r{^([-\w.+]+/[-\w.+]*)}.freeze
    MIME_PARAM_RE = /^;([-\w.+]+)=([^;,]+)/.freeze

    attr_reader :content_type, :data

    def initialize(*args)
      super(*args)
      @data = @opaque
      if md = MIME_TYPE_RE.match(@data)
        @content_type = md[1]
        @data = @data[@content_type.length .. -1]
      end
      @content_type ||= 'text/plain'
      @mime_params = {}
      while md = MIME_PARAM_RE.match(@data)
        @mime_params[md[1]] = md[2]
        @data = @data[md[0].length .. -1]
      end
      if base64 = /^;base64/.match(@data)
        @data = @data[7 .. -1]
      end
      unless /^,/.match(@data)
        raise 'Invalid data URI'
      end
      @data = @data[1 .. -1]
      @data = base64 ? Base64.decode64(@data) : URI.decode(@data)
      if @data.respond_to?(:force_encoding) && charset = @mime_params['charset']
        @data.force_encoding(charset)
      end
    end
  end

  @@schemes['DATA'] = Data

end
