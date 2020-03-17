module RichUrls
  class QueryInterface
    attr_reader :elements

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

    def initialize
      @elements = []
    end

    def start(tag)
      @elements << El.new(tag)
    end

    def end(tag)
      el = @elements.reverse_each.detect { |el| el.open && el.tag == tag }
      el.close!
    end

    def text(str)
      el = @elements.detect(&:open)
      el.append_text(str)
    end

    def attr(key, value)
      el = @elements.last
      el.add(key, value)
    end
  end
end
