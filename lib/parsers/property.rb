module RichUrls
  module Parsers
    Property = ->(property, _) { property&.force_encoding('UTF-8') }
  end
end
