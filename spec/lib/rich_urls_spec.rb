require 'spec_helper'

RSpec.describe RichUrls do
  it 'not a url' do
    expect { RichUrls.enrich('not-a-url') }
      .to raise_error(RichUrls::MalformedURLError)
  end

  it 'enriches a url' do
    enriched = RichUrls.enrich('https://wetransfer.com')

    expect(enriched).to have_key('title')
    expect(enriched).to have_key('description')
    expect(enriched).to have_key('embed')
    expect(enriched).to have_key('image')
    expect(enriched).to have_key('provider_display')
    expect(enriched).to have_key('favicon')
  end

  it 'enriches a url with a filter' do
    enriched = RichUrls.enrich('https://wetransfer.com', filter: %w[title])

    expect(enriched).to have_key('title')
    expect(enriched).to_not have_key('description')
    expect(enriched).to_not have_key('embed')
    expect(enriched).to_not have_key('image')
    expect(enriched).to_not have_key('provider_display')
    expect(enriched).to_not have_key('favicon')
  end

  context '#config' do
    it 'sets a custom wrapper as the caching wrapper' do
      RichUrls.cache = RichUrls::Cache::RedisWrapper.new

      expect(RichUrls.cache).to be_a(RichUrls::Cache::RedisWrapper)
    end

    it 'sets none as the caching wrapper' do
      RichUrls.cache = RichUrls::Cache::None.new

      expect(RichUrls.cache).to be_a(RichUrls::Cache::None)
    end

    it 'sets headesr' do
      RichUrls.headers = {'User-Agent' => 'test user agent' }

      expect(RichUrls.headers).to eq({
        'User-Agent' => 'test user agent'
      })
    end
  end
end
