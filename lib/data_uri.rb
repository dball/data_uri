require 'uri'
require 'base64'

module URI

  class Data < Generic

    COMPONENT = [:scheme, :opaque].freeze
    OPAQUE_REGEXP = /^([^;]+);base64,(.+)$/.freeze

    attr_reader :content_type, :data

    def initialize(*args)
      super(*args)
      if OPAQUE_REGEXP.match(@opaque)
        @content_type = $1
        @data = Base64.decode64($2)
      end
    end
  end

  @@schemes['DATA'] = Data

end
