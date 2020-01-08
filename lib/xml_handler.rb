class RichUrls
  class XMLHandler < ::Ox::Sax
    WHITELISTED_EL_NAMES = %i(
      html
      head
      title
      meta
      img
    ).freeze

    El = Struct.new(:name, :attributes)

    attr_accessor :elements

    def initialize
      @elements = []
    end

    def find
      @elements.detect { |el| yield el }
    end

    def start_element(element_name)
      return unless WHITELISTED_EL_NAMES.include?(element_name)

      @elements << El.new(element_name, {})
    end

    def attr(name, str)
      el = @elements.last
      el.attributes[name] = str
    end

    def text(str)
      el = @elements.last
      el && el.attributes[:text].nil? && el.attributes[:text] = str
    end
  end
end
