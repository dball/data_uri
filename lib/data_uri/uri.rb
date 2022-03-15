# frozen_string_literal: true

module URI
  class Data < Generic
    COMPONENT = %i[scheme opaque].freeze
    MIME_TYPE_RE = %r{^([-\w.+]+/[-\w.+]*)}
    MIME_PARAM_RE = /^;([-\w.+]+)=([^;,]+)/

    attr_reader :content_type, :data

    def initialize(*args)
      if args.length == 1
        uri = args.first.to_s
        raise URI::InvalidURIError, "Invalid Data URI: #{args.first.inspect}" unless uri.match(/^data:/)

        @scheme = 'data'
        @opaque = uri[5..]
      else
        super(*args)
      end

      @data = @opaque

      if (md = MIME_TYPE_RE.match(@data))
        @content_type = md[1]
        @data = @data[@content_type.length..]
      end

      @content_type ||= 'text/plain'
      @mime_params = {}

      while (md = MIME_PARAM_RE.match(@data))
        @mime_params[md[1]] = md[2]
        @data = @data[md[0].length..]
      end

      if (base64 = /^;base64/.match(@data))
        @data = @data[7..]
      end

      raise URI::InvalidURIError, 'Invalid data URI' unless /^,/.match(@data)

      @data = @data[1..]
      @data = base64 ? Base64.decode64(@data) : URI.decode_www_form_component(@data)

      return unless @data.respond_to?(:force_encoding) && (charset = @mime_params['charset'])

      @data.force_encoding(charset)
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
      raise "Invalid build argument: #{arg.inspect}" unless data

      content_type = data.content_type if !content_type && data.respond_to?(:content_type)
      new('data', nil, nil, nil, nil, nil, "#{content_type};base64,#{Base64.encode64(data.read).chop}", nil, nil)
    end
  end

  scheme_list['DATA'] = Data
end
