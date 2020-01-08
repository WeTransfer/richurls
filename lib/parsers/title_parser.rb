module Parsers
  TitleParser = lambda do |document, _|
    meta_el = document.find do |f|
      f.name == :meta && f.attributes[:property] == 'og:title'
    end

    title_el = document.find { |f| f.name == :title }

    meta_el && meta_el.attributes[:content] ||
      title_el && title_el.attributes[:text]
  end
end
