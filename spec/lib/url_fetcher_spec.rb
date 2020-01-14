require 'spec_helper'

RSpec.describe RichUrls::UrlFetcher do
  let(:url) { 'https://wetransfer.com' }
  let(:redis) { Redis.new }

  before do
    redis.flushall

    response = Patron::Response.new(
      url,
      200,
      0,
      "HTTP/2 200 OK\ndate: Mon, 13 Jan 2020 13:50:03 GMT",
      File.read('./spec/fixtures/wetransfer_static.html')
    )

    expect_any_instance_of(Patron::Session).to receive(:get)
      .with(url)
      .once
      .and_return(response)
  end

  it 'sets values to redis' do
    RichUrls::UrlFetcher.fetch(url)
    key = Digest::MD5.hexdigest(url)

    expect(redis.get(key)).to_not be_empty
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
