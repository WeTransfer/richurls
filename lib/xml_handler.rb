require_relative 'query_interface'

module RichUrls
  class XMLHandler < ::Ox::Sax
    def initialize
      @query_interface = QueryInterface.new
    end

    def find(tag, attrs = {})
      elements.detect do |el|
        matching_attributes = attrs.all? { |k, v| el.attributes[k] == v }

        el.tag == tag && matching_attributes
      end
    end

    def elements
      @elements ||= @query_interface.elements
    end

    def start_element(element_name)
      @query_interface.start(element_name)
    end

    def end_element(element_name)
      @query_interface.end(element_name)
    end

    def attr(name, str)
      @query_interface.attr(name, str)
    end

    def text(str)
      @query_interface.text(str)
    end
  end
end
