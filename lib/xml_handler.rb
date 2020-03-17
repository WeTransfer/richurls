require_relative 'query'
require_relative 'query_interface'

module RichUrls
  class XMLHandler < ::Ox::Sax
    def initialize
      @query_interface = QueryInterface.new
    end

    def elements
      @query_interface.elements
    end

    private

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
