module Parsers
  ProviderDisplayParser = -> (_, url) { URI(url).host }
end
