require_relative 'el'
require_relative 'finders'
require_relative 'finders/meta_title'
require_relative 'finders/meta_description'
require_relative 'finders/meta_image'
require_relative 'finders/favicon'

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

    FALLBACK_ELEMENTS = {
      img: 'og:image',
      p: 'og:description',
      title: 'og:title'
    }.freeze

    FINDERS = {
      Finders::MetaTitle => 'title',
      Finders::MetaDescription => 'description',
      Finders::MetaImage => 'image',
      Finders::Favicon => 'favicon',
      Finders::Title => 'title',
      Finders::Description => 'description',
      Finders::Image => 'image'
    }.freeze

    StopParsingError = Class.new(StandardError)

    attr_reader :elements, :properties

    def initialize(filter = [])
      @filter = filter
      @elements = []
      @counts = Set.new
      @properties = filtered_properties(filter)
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
      return unless el

      el.close!
      find_element(el)

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

    def find_element(elem)
      FINDERS.each_pair do |finder, attribute|
        next if @properties[attribute]

        content = finder.call(elem)

        if content
          @properties[attribute] = content
          break
        end
      end
    end

    def add_element?(tag)
      return true unless FALLBACK_ELEMENTS.keys.include?(tag)
      return false if @counts.include?(tag)

      @counts.add(tag)

      !find(:meta, property: FALLBACK_ELEMENTS.fetch(tag))
    end

    def filtered_properties(filter)
      keys = FINDERS.values.uniq
      keys &= filter if filter.any?

      Hash[keys.zip([nil] * keys.length)]
    end
  end
end
