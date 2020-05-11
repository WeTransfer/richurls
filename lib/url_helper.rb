require 'addressable'

class UrlHelper
  def self.url_for(domain, url)
    new(domain, url).url
  end

  private_class_method :new

  def initialize(domain, url)
    @domain = domain
    @url = url
  end

  def url
    return if @url.nil?

    parsed = Addressable::URI.parse(@url)
    full_url = valid?(parsed) ? parsed.to_s : domain_uri
    Addressable::URI.escape(full_url)
  rescue Addressable::URI::InvalidURIError
  end

  private

  def valid?(parsed)
    parsed.host && (parsed.scheme || @url.start_with?('//'))
  end

  def domain_uri
    domain = Addressable::URI.parse(@domain)
    domain.query = nil
    domain.path = if @url.start_with?('/')
                    @url
                  else
                    domain.path + '/' + @url
                  end
    domain.to_s
  end
end
