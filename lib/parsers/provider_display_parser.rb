module Parsers
  ProviderDisplayParser = lambda do |_, url|
    uri = URI(url)

    uri.scheme + '://' + uri.host
  end
end
