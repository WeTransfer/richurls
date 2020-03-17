# richurls [![Build Status](https://travis-ci.com/WeTransfer/richurls.svg?branch=master)](https://travis-ci.com/WeTransfer/richurls)
A gem which can enrich urls with speed.

**Installation**

```
gem install richurls
```

**Usage:**

```ruby
require 'richurls'

RichUrls.enrich('https://wetransfer.com')

# Returns:
# {
#   "title"=>"WeTransfer",
#   "description"=>"WeTransfer is the simplest way to send your files around the world",
#   "image"=>"https://prod-cdn.wetransfer.net/assets/wt-facebook-568be8def5a86a09cedeb21b8f24cb208e86515a552bd07d856c7d5dfc6a23df.png",
#   "provider_display"=>"https://wetransfer.com",
#   "favicon"=>"https://prod-cdn.wetransfer.net/assets/favicon-d12161435ace47c6883360e08466508593325f134c1852b1d0e6e75d5f76adda.ico",
#   "embed"=>nil
# }
```

**Caching:**

By default caching is turned off. Caching can be enabled by writing a cache wrapper as such:

```ruby
class CustomCache < RichUrls::Cache::Wrapper
  def initialize(time:)
    # Initialize the cache object by setting how long the cache will last
  end

  def get(key)
    # Callback for fetching a cache entry
  end

  def set(key, value)
    # Callback for setting a value in a cache to a certain key
  end

  def extend(key)
    # Callback for extending a cached value by key
  end
end
```

Finally you can enable the `CustomCache` by adding:

```ruby
RichUrls.cache = CustomCache.new(time: 2.hours)
```
