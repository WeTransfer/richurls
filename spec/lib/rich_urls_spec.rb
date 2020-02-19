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

  context '#config' do
    it 'sets a caching wrapper' do
      expect(ENV).to receive(:fetch)
        .with('RICH_URLS_CACHING', 'none')
        .and_return('redis')

      expect(RichUrls.cache).to eq(Cache::RedisWrapper)
    end

    it 'disables the caching wrapper' do
      expect(RichUrls.cache).to eq(Cache::NoneWrapper)
    end
  end
end
