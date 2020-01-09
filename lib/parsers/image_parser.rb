module Parsers
  class ImageParser
    def self.call(document, url)
      meta_image = document.find(:meta, property: 'og:image')
      image_tag = document.find(:img)

      image_source =
        (meta_image && meta_image.attributes[:content]) ||
        (image_tag && image_tag.attributes[:src])

      image_source && UrlHelper.url_for(url, image_source)
    end
  end
end
