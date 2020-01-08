module Parsers
  class ImageParser
    TRAILING_SLASH_REGEXP = /(\/)+$/.freeze

    def self.call(document, url)
      new(document, url).call
    end

    private_class_method :new

    def initialize(document, url)
      @document = document
      @url = url
    end

    def call
      if image_source =~ URI::DEFAULT_PARSER.make_regexp
        image_source
      elsif image_source
        url_no_trailing_slash = @url.sub(TRAILING_SLASH_REGEXP, '')

        [url_no_trailing_slash, image_source].join('/')
      end
    end

    private

    def image_source
      @image_source ||= begin
        meta_image = @document.find {|f| f.name == :meta && f.attributes[:property] == 'og:image' }
        image_tag = @document.find {|f| f.name == :img }

        (meta_image && meta_image.attributes[:content]) || (image_tag && image_tag.attributes[:src])
      end
    end
  end
end
