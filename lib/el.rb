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

      @attributes[:text] ||= ''

      if @attributes[:text].length <= MAX_TEXT_LENGTH
        end_slice = MAX_TEXT_LENGTH - @attributes[:text].length
        sliced = str[0...end_slice]

        @attributes[:text] << sliced + ' '
      end
    end

    def text
      @attributes[:text].strip
    end

    def close!
      @open = false
    end
  end
end
