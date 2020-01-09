module Parsers
  FaviconParser = lambda do |document, url|
    favicon_el = document.find(:link, rel: 'shortcut icon')

    favicon_el && UrlHelper.url_for(url, favicon_el.attributes[:href])
  end
end
