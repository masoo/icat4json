require "icat4json/version"
require "net/http"
require "uri"
require "json"

module ICat4JSON
  class Error < StandardError; end
  class ConnectionError < Error; end
  class ParseError < Error; end

  class ICat4JSON
    attr_reader :json, :icat

    MAX_RESPONSE_SIZE = 1_048_576

    ICATData = Struct.new(:itemdata, :docTitle, :docTitleFix, :docLink, :docDate)
    ItemData = Struct.new(:item_title, :item_link, :item_date, :item_identifier)

    def initialize
      raw = fetch_feed
      @json = parse_json(raw)
      @icat = build_icat_data(@json)
    end

    private

    def fetch_feed
      uri = URI.parse(icat4json_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 10
      http.read_timeout = 10

      response = http.request(Net::HTTP::Get.new(uri))
      unless response.is_a?(Net::HTTPSuccess)
        raise ConnectionError, "HTTP request failed with status #{response.code}"
      end

      body = response.body
      raise Error, "Response too large: #{body.bytesize} bytes" if body.bytesize > MAX_RESPONSE_SIZE
      body.encode("UTF-8")
    rescue SocketError, Timeout::Error => e
      raise ConnectionError, "HTTP request failed: #{e.message}"
    end

    def parse_json(raw)
      JSON.parse(raw)
    rescue JSON::ParserError => e
      raise ParseError, "JSON parsing failed: #{e.message}"
    end

    def build_icat_data(json)
      ICATData.new(
        itemdata: build_item_data(json["itemdata"]),
        docTitle: json["docTitle"],
        docTitleFix: json["docTitleFix"],
        docLink: json["docLink"],
        docDate: json["docDate"]
      )
    end

    def build_item_data(items)
      return [] if items.nil?
      items.map do |h|
        ItemData.new(
          item_title: h["item_title"],
          item_link: h["item_link"],
          item_date: h["item_date"],
          item_identifier: h["item_identifier"]
        )
      end
    end

    # analize https://www.ipa.go.jp/security/announce/irss/icatw2.js
    def icat4json_url
      "https://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?#{Time.now.to_i}&tool=icatw"
    end
  end

  def self.new(*args, &block)
    ICat4JSON.new(*args, &block)
  end
end
