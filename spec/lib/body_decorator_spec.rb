require 'spec_helper'

RSpec.describe RichUrls::BodyDecorator do
  let(:url) { 'https://body.com' }

  describe 'provider display decorator' do
    let(:file) { File.binread('./spec/fixtures/title_only.html') }

    it 'adds a provider display - removes path' do
      result = RichUrls::BodyDecorator.new(
        'https://wetransfer.com/test',
        file
      ).decorate

      expect(result['provider_display']).to eq('wetransfer.com')
    end

    it 'adds a provider display - strips of params' do
      result = RichUrls::BodyDecorator.new(
        'https://wetransfer.com/test?params=1',
        file
      ).decorate

      expect(result['provider_display']).to eq('wetransfer.com')
    end

    it 'adds a provider display - keeps www' do
      result = RichUrls::BodyDecorator.new(
        'https://www.wetransfer.com/test?params=1',
        file
      ).decorate

      expect(result['provider_display']).to eq('www.wetransfer.com')
    end
  end

  describe 'title decorator' do
    it 'selects the title element' do
      file = File.binread('./spec/fixtures/title_only.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['title']).to eq('This is a title')
      expect(result['embed']).to eq(nil)
    end

    it 'selects the arabic title element' do
      file = File.binread('./spec/fixtures/arabic_title.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['title']).to eq('هذا هو اللقب')
    end

    it 'selects the meta title over the title' do
      file = File.binread('./spec/fixtures/meta_title.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['title']).to eq('This is another title')
    end
  end

  describe 'description decorator' do
    it 'fetches the correct description' do
      file = File.binread('./spec/fixtures/meta_description.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['description']).to eq('This is a description')
    end

    it 'fetches the correct description' do
      file = File.binread('./spec/fixtures/p_description.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['description']).to eq('This is a description with a link')
    end

    it 'fetches the correct description including odd utf-8 chars' do
      file = File.binread('./spec/fixtures/weird-utf8-bytes.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate
      expect(result['description']).to eq(
        'This is a description with another link'
      )
    end

    it 'fetches the correct description including images' do
      file = File.binread('./spec/fixtures/p_img_description.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['description']).to eq(
        'This is a description with another link'
      )
    end
  end

  describe 'image decorator' do
    it 'decorates a html body - appends the url' do
      file = File.binread('./spec/fixtures/meta_image.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['image']).to eq('https://body.com/cats.jpg')
    end

    it 'decorates a html body - does not append with a non-relative url' do
      file = File.binread('./spec/fixtures/image_tags.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['image']).to eq('https://www.test.com/smiley1.gif')
    end

    it 'decorates a html body - appends the url' do
      file = File.binread('./spec/fixtures/relative_image_tags.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['image']).to eq('https://body.com/smiley1.gif')
    end
  end

  describe 'favicon decorator' do
    it 'adds the non-relative url' do
      file = File.binread('./spec/fixtures/favicon.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['favicon']).to eq('https://cats-are-god.com/cats.ico')
    end

    it 'adds the relative url' do
      file = File.binread('./spec/fixtures/favicon_relative.html')
      result = RichUrls::BodyDecorator.new(
        'https://body.com/123/abc?params=xyz',
        file
      ).decorate

      expect(result['favicon']).to eq('https://body.com/cats.ico')
    end

    it 'adds the relative url' do
      file = File.binread('./spec/fixtures/favicon_relative.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['favicon']).to eq('https://body.com/cats.ico')
    end

    it 'adds a favicon - even if it is not according to the spec' do
      file = File.binread('./spec/fixtures/favicon_rel.html')
      result = RichUrls::BodyDecorator.new(url, file).decorate

      expect(result['favicon']).to eq('https://cats-are-god.com/cats.ico')
    end
  end

  it 'does not spawn a NoMethodError with a src on a script' do
    file = File.binread('./spec/fixtures/test_script_before.html')
    result = RichUrls::BodyDecorator.new(url, file).decorate

    expect(result['provider_display']).to eq('body.com')
  end
end
