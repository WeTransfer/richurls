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

    context 'spotify' do
      context 'a track' do
        let(:url) {
          'https://open.spotify.com/track/' \
          '40JHx9UKFZTPKrA9a3ScaG?si=1GJj3YzESxyz8-27tQ9KdQ'
        }

        it 'fetches the correct embed code' do
          expect(result).to eq(
            '<iframe '\
            'src="https://open.spotify.com/embed/track/40JHx9UKFZTPKrA9a3ScaG" '\
            'width="300" height="380" frameborder="0" allowtransparency="true" '\
            'allow="encrypted-media"></iframe>'
          )
        end
      end

      context 'an album' do
        let(:url) {
          'https://open.spotify.com/album/' \
          '1MrqY9fdmJFExV6cWhxgQ6?si=KvHon650TW24sXCXuFw1WA'
        }

        it 'fetches the correct embed code' do
          expect(result).to eq(
            '<iframe '\
            'src="https://open.spotify.com/embed/album/1MrqY9fdmJFExV6cWhxgQ6" '\
            'width="300" height="380" frameborder="0" allowtransparency="true" '\
            'allow="encrypted-media"></iframe>'
          )
        end
      end

      context 'a playlist' do
        let(:url) {
          'https://open.spotify.com/playlist/' \
          '7cHfzO6YdgHMy9tVOEGb3J?si=S5bfYRLDSZapgjGdfNsW6w'
        }

        it 'fetches the correct embed code' do
          expect(result).to eq(
            '<iframe '\
            'src="https://open.spotify.com/embed/album/1MrqY9fdmJFExV6cWhxgQ6" '\
            'width="300" height="380" frameborder="0" allowtransparency="true" '\
            'allow="encrypted-media"></iframe>'
          )
        end
      end
    end

    # Out of scope. Soundcloud's URL's can't be easily transformed into
    # an iframe because of the way this is currently setup at Soundcloud's end.
    context 'soundcloud'

    # Out of scope. Twitter URL's can't be easily transformed into
    # an iframe because of the way it's currently setup at Twitter's end
    context 'twitter'
  end
end
