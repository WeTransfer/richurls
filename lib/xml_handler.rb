require_relative 'el'

module RichUrls
  class XMLHandler < ::Ox::Sax
    WHITELISTED_EL_NAMES = %i[
      title
      meta
      link
      img
      p
    ].freeze

    WHITELISTED_ATTRS = %i[
      property
      content
      rel
      href
      src
    ].freeze

    attr_reader :elements

    def initialize
      @elements = []
    end

    def find(tag, attrs = {})
      elements.detect do |el|
        matching_attributes = attrs.all? { |k, v| el.attributes[k] == v }

        el.tag == tag && matching_attributes
      end
    end

    def start_element(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      @elements << El.new(tag)
    end

    def end_element(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      el = @elements.reverse_each.detect { |el| el.open && el.tag == tag }
      el.close!
    end

    def attr(key, value)
      return unless WHITELISTED_ATTRS.include?(key)

      el = @elements.last
      el && el.add(key, value)
    end

    def text(str)
      el = @elements.detect(&:open)
      el && el.append_text(str)
    end
  end
end
