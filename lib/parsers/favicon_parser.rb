module Parsers
  FaviconParser = lambda do |document, url|
    favicon_el = document.find(:link, rel: %w[shortcut icon])
    icon_el = document.find(:link, rel: %w[icon])

    (favicon_el && UrlHelper.url_for(url, favicon_el.attributes[:href])) ||
      (icon_el && UrlHelper.url_for(url, icon_el.attributes[:href]))
  end
end
