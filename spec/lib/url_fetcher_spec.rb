require 'spec_helper'

RSpec.describe RichUrls::UrlFetcher do
  let(:url) { 'https://wetransfer.com' }
  let(:redis) { Redis.new }

  before do
    RichUrls.cache = RichUrls::Cache::RedisWrapper.new
    redis.flushall

    response = Patron::Response.new(
      url,
      200,
      0,
      "HTTP/2 200 OK\ndate: Mon, 13 Jan 2020 13:50:03 GMT",
      File.read('./spec/fixtures/wetransfer.html')
    )

    expect_any_instance_of(Patron::Session).to receive(:get)
      .with(url)
      .once
      .and_return(response)
  end

  it 'sets values to redis' do
    RichUrls::UrlFetcher.fetch(url)
    key = Digest::MD5.hexdigest(url)

    expect(redis.get(key)).to_not be_nil
  end

  it 'sets the ttl to a custom time' do
    RichUrls::UrlFetcher.fetch(url, [], 50)
    key = Digest::MD5.hexdigest(url)

    expect(redis.ttl(key)).to eq(50)
    sleep 1
    expect(redis.ttl(key)).to eq(49)

    RichUrls::UrlFetcher.fetch(url, [], 90)
    expect(redis.ttl(key)).to eq(90)
  end

  it 'does not cache' do
    RichUrls::UrlFetcher.fetch(url, [], 0)
    key = Digest::MD5.hexdigest(url)

    expect(redis.get(key)).to be_nil
  end

  it 'invalidates a cache' do
    RichUrls::UrlFetcher.fetch(url, [], 50)
    key = Digest::MD5.hexdigest(url)

    expect(redis.ttl(key)).to eq(50)
    sleep 1
    expect(redis.ttl(key)).to eq(49)

    RichUrls::UrlFetcher.fetch(url, [], 0)
    expect(redis.get(key)).to be_nil
  end

  it 'sets values to redis incl. attributes regardless of order' do
    RichUrls::UrlFetcher.fetch(url, %w[title description])
    key = Digest::MD5.hexdigest(url + 'description-title')

    expect(redis.ttl(key)).to eq(3600)
    sleep 1
    expect(redis.ttl(key)).to eq(3599)

    RichUrls::UrlFetcher.fetch(url, %w[description title])
    expect(redis.ttl(key)).to eq(3600)
  end

  it 'elongates the ttl if the redis key is called again' do
    RichUrls::UrlFetcher.fetch(url)
    key = Digest::MD5.hexdigest(url)

    expect(redis.ttl(key)).to eq(3600)
    sleep 1
    expect(redis.ttl(key)).to eq(3599)

    RichUrls::UrlFetcher.fetch(url)
    expect(redis.ttl(key)).to eq(3600)
  end
end
