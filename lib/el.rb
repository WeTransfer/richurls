module RichUrls
  class El
    MAX_TEXT_LENGTH = 1000

    attr_reader :tag, :open, :attributes

    def initialize(tag)
      @tag = tag
      @open = true
      @attributes = {}
    end

    def add(key, value)
      @attributes[key] = value
    end

    def append_text(str)
      str = str.strip

      if @attributes[:text]
        if @attributes[:text].length <= MAX_TEXT_LENGTH
          @attributes[:text] << " #{str[0...(MAX_TEXT_LENGTH-@attributes[:text].length)-1]}"
        end
      else
        @attributes[:text] = str[0...MAX_TEXT_LENGTH]
      end
    end

    def close!
      @open = false
    end
  end
end
