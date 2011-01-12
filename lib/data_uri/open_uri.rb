module URI

  class Data

    def open
      io = StringIO.new(data)
      OpenURI::Meta.init(io)
      io.meta_add_field('content-type', content_type)
      if block_given?
        begin
          yield io
        ensure
          io.close
        end
      else
        io
      end
    end

  end

end
