module Parsers
  TitleParser = lambda do |document, _|
    meta_el = document.find(:meta, property: 'og:title')
    title_el = document.find(:title)

    meta_el && meta_el.attributes[:content] ||
      title_el && title_el.attributes[:text]
  end
end
