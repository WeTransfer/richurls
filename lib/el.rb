module RichUrls
  class El
    attr_reader :tag, :open, :attributes

    def initialize(tag, open = true)
      @tag = tag
      @open = open
      @attributes = {}
    end

    def add(key, value)
      @attributes[key] = value
    end

    def append_text(str)
      str = str.strip

      if @attributes[:text]
        @attributes[:text] << " #{str}"
      else
        @attributes[:text] = str
      end
    end

    def close!
      @open = false
    end
  end
end
