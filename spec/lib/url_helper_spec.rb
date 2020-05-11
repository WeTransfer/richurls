require 'spec_helper'

RSpec.describe UrlHelper do
  LIST_OF_VALID_URLS = %w[
    //test.com/favicon.ico
    https://test.com/favicon.ico
    https://www.test.com/favicon.ico
    http://test.com/favicon.ico
    http://www.test.com/favicon.ico
    http://www.test.com/favicon.ico?q=22
  ].freeze

  LIST_OF_INVALID_URLS = %w[
    http:
    https:
  ].freeze

  LIST_OF_VALID_URLS.each do |url|
    it "can handle #{url}" do
      url_handler = UrlHelper.url_for(
        'https://should_not_be_in_the_spec.com', url
      )

      expect(url_handler).to eq(url)
    end
  end

  LIST_OF_INVALID_URLS.each do |url|
    it "returns nil for #{url}" do
      url_handler = UrlHelper.url_for(
        'https://should_not_be_in_the_spec.com', url
      )

      expect(url_handler).to eq(nil)
    end
  end

  it 'should prepend the domain' do
    url = UrlHelper.url_for(
      'https://should_be_in_the_spec.com/path?q=1', '/test.jpg'
    )

    expect(url).to eq(
      'https://should_be_in_the_spec.com/test.jpg'
    )
  end

  it 'should prepend the domain and the path' do
    url = UrlHelper.url_for(
      'https://should_be_in_the_spec.com/test?q=5', 'test.jpg'
    )

    expect(url).to eq(
      'https://should_be_in_the_spec.com/test/test.jpg'
    )
  end

  it 'should encode non-ascii characters' do
    url = UrlHelper.url_for(
      'https://should_be_in_the_spec.com', 'test-©.jpg'
    )

    expect(url).to eq(
      'https://should_be_in_the_spec.com/test-%C2%A9.jpg'
    )
  end

  describe 'should escape whitespaces' do
    it 'escapes whitespace characters' do
      url = UrlHelper.url_for(
        'https://should_not_be_in_the_spec.com',
        'https://test.com/abc\n  test.jpg'
      )

      expect(url).to eq('https://test.com/abc%5Cn%20%20test.jpg')
    end
  end

  describe 'should strip whitespace' do
    it 'when at the end of a relative url' do
      url = UrlHelper.url_for(
        'https://should_be_in_the_spec.com/test?q=5', 'test.jpg '
      )

      expect(url).to eq(
        'https://should_be_in_the_spec.com/test/test.jpg%20'
      )
    end

    it 'when at the end of an actual url' do
      url = UrlHelper.url_for(
        'https://should_not_be_in_the_spec.com/test?q=5',
        'https://should_be_in_the_spec.com/test/test.jpg '
      )

      expect(url).to eq(
        'https://should_be_in_the_spec.com/test/test.jpg%20'
      )
    end
  end
end
