require 'patron'

module RichUrls
  DEFAULT_TIMEOUT = 10 # seconds

  class Browser
    def self.remote_call(url)
      new(url).remote_call
    end

    private_class_method :new

    def remote_call
      raise NotImplementedError,
            'subclasses of Browser need a remote_call method'
    end
  end

  class PatronBrowser < Browser
    def initialize(url)
      @url = url
    end

    def remote_call
      session = Patron::Session.new(
        timeout: DEFAULT_TIMEOUT,
        headers: RichUrls.headers
      )

      response = session.get(@url)

      [response.status, response.url, response.body]
    end
  end
end
