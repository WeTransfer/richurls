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
      return if @attributes[key]

      @attributes[key] = value
    end

    def append_text(str)
      @attributes[:text] ||= ''

      str = str.strip
      length = @attributes[:text].length

      if length <= MAX_TEXT_LENGTH
        end_slice = MAX_TEXT_LENGTH - length
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
