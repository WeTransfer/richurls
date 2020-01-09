require 'spec_helper'

RSpec.describe Parsers::EmbedParser do
  let(:result) { Parsers::EmbedParser.call(nil, url) }

  describe 'embed parser' do
    describe 'youtube full link' do
      let(:url) { 'https://www.youtube.com/watch?v=ONYyFiKjJ20' }

      it 'fetches the embed code from a page like Youtube' do
        expect(result).to eq(
          '<iframe width="560" height="315" '\
          'src="https://www.youtube.com/embed/ONYyFiKjJ20" frameborder="0" '\
          'allow="accelerometer; autoplay; encrypted-media; gyroscope; '\
          'picture-in-picture" allowfullscreen></iframe>'
        )
      end
    end

    describe 'youtube short link' do
      let(:url) { 'https://youtu.be/4gLrlolyDag' }

      it 'fetches the embed code from a page like Youtube' do
        expect(result).to eq(
          '<iframe width="560" height="315" '\
          'src="https://www.youtube.com/embed/4gLrlolyDag" frameborder="0" '\
          'allow="accelerometer; autoplay; encrypted-media; gyroscope; '\
          'picture-in-picture" allowfullscreen></iframe>'
        )
      end
    end

    context 'paste' do
      let(:url) { 'https://pasteapp.com/p/jbYfTeB8726?view=xhund8bMW4W' }

      it 'fetches the embed code from a page like Paste' do
        expect(result).to eq(
          '<iframe '\
          'src="https://pasteapp.com/p/jbYfTeB8726/embed?view=xhund8bMW4W" '\
          'width="480" height="480" scrolling="no" frameborder="0" '\
          'allowfullscreen></iframe>'
        )
      end
    end
  end
end
