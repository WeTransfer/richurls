require 'spec_helper'

RSpec.describe RichUrls::BodyDecorator do
  describe 'embed decorator' do
    describe 'youtube' do
      let(:file) { File.read('./spec/fixtures/youtube_video.html') }

      let(:result) {
        decorator = RichUrls::BodyDecorator.new(
          'https://www.youtube.com/watch?v=ONYyFiKjJ20',
          file
        )

        result = decorator.decorate
      }

      it 'provider display matches' do
        expect(result['provider_display']).to eq('https://www.youtube.com')
      end

      it 'fetches the embed code from a page like Youtube' do
        expect(result['embed']).to eq(
          '<iframe width="560" height="315" '\
          'src="https://www.youtube.com/embed/ONYyFiKjJ20" frameborder="0" '\
          'allow="accelerometer; autoplay; encrypted-media; gyroscope; '\
          'picture-in-picture" allowfullscreen></iframe>'
        )
      end
    end

    it 'fetches the embed code from a page like Paste' do
      file = File.read('./spec/fixtures/paste_slideshow.html')
      decorator = RichUrls::BodyDecorator.new(
        'https://pasteapp.com/p/jbYfTeB8726?view=xhund8bMW4W',
        file
      )
      result = decorator.decorate

      expect(result['embed']).to eq(
        '<iframe '\
        'src="https://pasteapp.com/p/jbYfTeB8726/embed?view=xhund8bMW4W" '\
        'width="480" height="480" scrolling="no" frameborder="0" '\
        'allowfullscreen></iframe>'
      )
    end
  end

end
