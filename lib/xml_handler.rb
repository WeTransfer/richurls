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

    StopParsingError = Class.new(StandardError)

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

      el = @elements.reverse_each.detect { |e| e.open && e.tag == tag }
      el.close!

      raise StopParsingError if stop?
    end

    def attr(key, value)
      return unless WHITELISTED_ATTRS.include?(key)

      el = @elements.last
      el&.add(key, value)
    end

    def text(str)
      el = @elements.detect(&:open)
      el&.append_text(str)
    end

    private

    def stop?
      p_tag = find(:p)
      img_tag = find(:img)

      p_tag && img_tag && !(p_tag.open && img_tag.open)
    end
  end
end
