module Parsers
  FaviconParser = lambda do |document, url|
    favicon_el = document.find do |el|
      el.name == :link && el.attributes[:rel] == 'shortcut icon'
    end

    favicon_el && UrlHelper.url_for(url, favicon_el.attributes[:href])
  end
end
