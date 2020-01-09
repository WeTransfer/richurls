module RichUrls
  class XMLHandler < ::Ox::Sax
    WHITELISTED_EL_NAMES = %i[
      html
      head
      title
      meta
      link
      img
    ].freeze

    WHITELISTED_ATTRS = %i[
      property
      content
      rel
      href
      src
    ].freeze

    El = Struct.new(:name, :attributes)

    attr_accessor :elements

    def initialize
      @elements = []
    end

    def find(name, attributes = {})
      @elements.detect do |el|
        matching_attributes = attributes.all? do |key, val|
          el.attributes[key] == val
        end

        el.name == name && matching_attributes
      end
    end

    def start_element(element_name)
      return unless WHITELISTED_EL_NAMES.include?(element_name)

      @elements << El.new(element_name, {})
    end

    def attr(name, str)
      return unless WHITELISTED_ATTRS.include?(name)

      el = @elements.last
      el.attributes[name] = str
    end

    def text(str)
      el = @elements.last
      el && el.attributes[:text].nil? && el.attributes[:text] = str
    end
  end
end
