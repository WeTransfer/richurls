require 'spec_helper'

RSpec.describe RichUrls::BodyDecorator do
  let(:url) { 'https://body.com' }

  describe 'provider display decorator' do
    let(:file) { File.read('./spec/fixtures/title_only.html') }

    it 'adds a provider display - removes path' do
      decorator = RichUrls::BodyDecorator.new(
        'https://wetransfer.com/test',
        file
      )
      result = decorator.decorate

      expect(result['provider_display']).to eq('wetransfer.com')
    end

    it 'adds a provider display - strips of params' do
      decorator = RichUrls::BodyDecorator.new(
        'https://wetransfer.com/test?params=1',
        file
      )
      result = decorator.decorate

      expect(result['provider_display']).to eq('wetransfer.com')
    end

    it 'adds a provider display - keeps www' do
      decorator = RichUrls::BodyDecorator.new(
        'https://www.wetransfer.com/test?params=1',
        file
      )
      result = decorator.decorate

      expect(result['provider_display']).to eq('www.wetransfer.com')
    end
  end

  describe 'title decorator' do
    it 'selects the title element' do
      file = File.read('./spec/fixtures/title_only.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['title']).to eq('This is a title')
      expect(result['embed']).to eq(nil)
    end

    it 'selects the arabic title element' do
      file = File.read('./spec/fixtures/arabic_title.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['title']).to eq('هذا هو اللقب')
    end

    it 'selects the meta title over the title' do
      file = File.read('./spec/fixtures/meta_title.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['title']).to eq('This is another title')
    end
  end

  describe 'description decorator' do
    it 'fetches the correct description' do
      file = File.read('./spec/fixtures/meta_description.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['description']).to eq('This is a description')
    end

    it 'fetches the correct description including odd utf-8 chars' do
      file = File.read('./spec/fixtures/weird-utf8-bytes.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['description']).to eq('We’ve got you covered!')
    end
  end

  describe 'image decorator' do
    it 'decorates a html body - appends the url' do
      file = File.read('./spec/fixtures/meta_image.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://body.com/cats.jpg')
    end

    it 'decorates a html body - does not append with a non-relative url' do
      file = File.read('./spec/fixtures/image_tags.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://www.test.com/smiley1.gif')
    end

    it 'decorates a html body - appends the url' do
      file = File.read('./spec/fixtures/relative_image_tags.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['image']).to eq('https://body.com/smiley1.gif')
    end
  end

  describe 'favicon decorator' do
    it 'adds the non-relative url' do
      file = File.read('./spec/fixtures/favicon.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['favicon']).to eq('https://cats-are-god.com/cats.ico')
    end

    it 'adds the relative url' do
      file = File.read('./spec/fixtures/favicon_relative.html')
      decorator = RichUrls::BodyDecorator.new(
        'https://body.com/123/abc?params=xyz',
        file
      )
      result = decorator.decorate

      expect(result['favicon']).to eq('https://body.com/cats.ico')
    end

    it 'adds the relative url' do
      file = File.read('./spec/fixtures/favicon_relative.html')
      decorator = RichUrls::BodyDecorator.new(url, file)
      result = decorator.decorate

      expect(result['favicon']).to eq('https://body.com/cats.ico')
    end
  end
end
