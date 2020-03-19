require_relative 'el'

module RichUrls
  class XMLHandler < ::Ox::Sax
    KEYWORDS = ['shortcut icon', 'icon shortcut', 'icon'].freeze
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

    FALLBACK_ELEMENTS = {
      img: 'og:image',
      p: 'og:description',
      title: 'og:title'
    }.freeze

    StopParsingError = Class.new(StandardError)

    attr_reader :elements

    def initialize
      @elements = []
      @counts = Set.new
      @properties = {
        title: false,
        description: false,
        image: false,
        favicon: false
      }
    end

    def find(tag, attrs = {})
      @elements.detect do |el|
        matching_attributes = attrs.all? { |k, v| el.attributes[k] == v }

        el.tag == tag && matching_attributes
      end
    end

    def start_element(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      @elements << El.new(tag) if add_element?(tag)
    end

    def end_element(tag)
      return unless WHITELISTED_EL_NAMES.include?(tag)

      el = @elements.reverse_each.detect { |e| e.open && e.tag == tag }

      if el
        el.close!

        if el.tag == :meta && el.attributes[:property] == 'og:title'
          @properties[:title] = el.attributes[:content]
        end

        if el.tag == :title
          @properties[:title] = el.text
        end

        if el.tag == :meta && el.attributes[:property] == 'og:description'
          @properties[:description] = el.attributes[:content]
        end

        if el.tag == :p
          @properties[:description] = el.text
        end

        if el.tag == :meta && el.attributes[:property] == 'og:image'
          @properties[:image] = el.attributes[:content]
        end

        if el.tag == :img
          @properties[:image] = el.attributes[:src]
        end

        if el.tag == :link && KEYWORDS.include?(el.attributes[:rel])
          @properties[:favicon] = el.attributes[:href]
        end
      end

      raise StopParsingError if @properties.values.all?
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

    def add_element?(tag)
      return true unless FALLBACK_ELEMENTS.keys.include?(tag)
      return false if @counts.include?(tag)

      @counts.add(tag)

      !find(:meta, property: FALLBACK_ELEMENTS.fetch(tag))
    end
  end
end
