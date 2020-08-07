require 'patron'

module RichUrls
  DEFAULT_TIMEOUT = 10 # seconds

  class Browser
    def remote_call(url)
      raise NotImplementedError,
            'subclasses of Browser need a remote_call method'
    end
  end

  class PatronBrowser < Browser
    def remote_call(url)
      session = Patron::Session.new(
        timeout: DEFAULT_TIMEOUT,
        headers: RichUrls.headers
      )

      response = session.get(url)

      [response.status, response.url, response.body]
    end
  end
end
