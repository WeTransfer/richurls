module RichUrls
  module Finders
    Description = ->(elem) { elem.tag == :p && elem.text }
    Image = ->(elem) { elem.tag == :img && elem.attributes[:src] }
    Title = ->(elem) { elem.tag == :title && elem.text }
  end
end
