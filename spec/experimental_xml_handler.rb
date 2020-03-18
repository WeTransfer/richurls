class ExperimentalXMLHandler < ::Ox::Sax
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

  StopParsingError = Class.new(StandardError)
  El = Struct.new(:name, :attributes)

  attr_accessor :elements

  def initialize
    @elements = []
  end

  def find(name, attrs = {})
    @elements.detect do |el|
      matching_attributes = attrs.all? { |k, v| el.attributes[k] == v }

      el.name == name && matching_attributes
    end
  end

  def start_element(element_name)
    return unless WHITELISTED_EL_NAMES.include?(element_name)

    @elements << El.new(element_name, {})
  end

  def attr(name, str)
    el = @elements.last

    return unless el && WHITELISTED_ATTRS.include?(name)

    el.attributes[name] = str

    raise StopParsingError if stop?(name, el)
  end

  def text(str)
    el = @elements.last
    el && el.attributes[:text].nil? && el.attributes[:text] = str
  end

  private

  def stop?(name, elem)
    name == WHITELISTED_ATTRS.last && elem.name == :img
  end
end
