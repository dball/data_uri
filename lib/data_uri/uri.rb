module URI

  class Data < Generic

    COMPONENT = [:scheme, :opaque].freeze
    MIME_TYPE_RE = %r{^([-\w.+]+/[-\w.+]*)}.freeze
    MIME_PARAM_RE = /^;([-\w.+]+)=([^;,]+)/.freeze

    attr_reader :content_type, :data

    def initialize(*args)
      if args.length == 1
        uri = args.first.to_s
        unless uri.match(/^data:/)
          raise URI::InvalidURIError.new('Invalid Data URI: ' + args.first.inspect)
        end
        @scheme = 'data'
        @opaque = uri[5 .. -1]
      else
        super(*args)
      end
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
        raise URI::InvalidURIError.new('Invalid data URI')
      end
      @data = @data[1 .. -1]
      @data = base64 ? Base64.decode64(@data) : URI.decode(@data)
      if @data.respond_to?(:force_encoding) && charset = @mime_params['charset']
        @data.force_encoding(charset)
      end
    end

    def self.build(arg)
      data = nil
      content_type = nil
      case arg
        when IO
          data = arg
        when Hash
          data = arg[:data]
          content_type = arg[:content_type]
      end
      raise 'Invalid build argument: ' + arg.inspect unless data
      if !content_type && data.respond_to?(:content_type)
        content_type = data.content_type
      end
      new('data', nil, nil, nil, nil, nil, "#{content_type};base64,#{Base64.encode64(data.read).chop}", nil, nil)
    end
  end

  @@schemes['DATA'] = Data

end
