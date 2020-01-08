module Parsers
  DescriptionParser = lambda do |document, _|
    meta_el = document.find {|f| f.name == :meta && f.attributes[:property] == 'og:description' }

    meta_el && meta_el.attributes[:content]
  end
end
