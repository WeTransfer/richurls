module Parsers
  IFRAMES = {
    youtube: '<iframe width="560" height="315" src="%s" frameborder="0" '\
             'allow="accelerometer; autoplay; encrypted-media; '\
             'gyroscope; picture-in-picture" allowfullscreen>'\
             '</iframe>',
    paste: '<iframe src="%s" width="480" height="480" scrolling="no" '\
           'frameborder="0" allowfullscreen></iframe>'
  }.freeze

  EMBED_CONFIG = {
    /http(s)?\:\/\/(www\.)?youtube\.com\// => {
      template: :youtube,
      url_sub: [/watch\?v=/, 'embed/']
    },
    /http(s)?\:\/\/youtu\.be\// => {
      template: :youtube,
      url_sub: [/youtu\.be\/(.+)/, 'www.youtube.com/embed/\1']
    },
    /http(s)?\:\/\/(www\.)?pasteapp\.com\// => {
      template: :paste,
      url_sub: [/\?view=/, '/embed?view=']
    }
  }.freeze

  class EmbedParser
    def self.call(_, url)
      result = nil
      EMBED_CONFIG.each do |url_regex, template|
        next unless url =~ url_regex

        result = IFRAMES[template[:template]] % url.sub(*template[:url_sub])
        break
      end
      result
    end
  end
end
