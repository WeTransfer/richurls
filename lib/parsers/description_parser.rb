module Parsers
  DescriptionParser = lambda do |document, _|
    meta_el = document.find(:meta, property: 'og:description')
    p_el = document.find(:p)

    (meta_el && meta_el.attributes[:content]) ||
      (p_el && p_el.attributes[:text])
  end
end
