module Parsers
  DescriptionParser = lambda do |document, _|
    meta_el = document.find do |f|
      f.name == :meta && f.attributes[:property] == 'og:description'
    end

    meta_el && meta_el.attributes[:content]
  end
end
