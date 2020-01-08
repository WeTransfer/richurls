module Parsers
  class ImageParser
    def self.call(document, url)
      meta_image = document.find do |f|
        f.name == :meta && f.attributes[:property] == 'og:image'
      end

      image_tag = document.find { |f| f.name == :img }

      image_source =
        (meta_image && meta_image.attributes[:content]) ||
        (image_tag && image_tag.attributes[:src])

      image_source && UrlHelper.url_for(url, image_source)
    end
  end
end
