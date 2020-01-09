module Parsers
  DescriptionParser = lambda do |document, _|
    meta_el = document.find(:meta, property: 'og:description')

    meta_el && meta_el.attributes[:content]
  end
end
