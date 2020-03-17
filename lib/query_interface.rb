module RichUrls
  class QueryInterface
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

    require_relative './query_interface/el.rb'

    attr_reader :elements

    def initialize
      @elements = []
    end

    def start(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      @elements << El.new(tag)
    end

    def end(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      el = @elements.reverse_each.detect { |el| el.open && el.tag == tag }
      el.close!
    end

    def text(str)
      el = @elements.detect(&:open)
      el && el.append_text(str)
    end

    def attr(key, value)
      return unless WHITELISTED_ATTRS.include?(key)

      el = @elements.last
      el && el.add(key, value)
    end
  end
end
