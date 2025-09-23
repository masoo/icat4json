require "icat4json/version"
require "net/http"
require "uri"
require "json"

module ICat4JSON
  class ICat4JSON
    attr_accessor :json, :icat

    ICATData = Struct.new(:itemdata, :docTitle, :docTitleFix, :docLink, :docDate)
    ItemData = Struct.new(:item_title, :item_link, :item_date, :item_identifier)

    def initialize
      uri = URI.parse(icat4json_url)
      http = Net::HTTP.get(uri)
      @json = JSON.parse(http)
      @icat = ICATData.new
      @json.each {|k, v| icat[k] = v unless k == "itemdata" }
      @icat[:itemdata] = []
      @json["itemdata"].each do |itemdata|
        item = ItemData.new
        itemdata.each do |k,v|
          item[k] = v
        end
        @icat[:itemdata].push item
      end
      true
    end

    private

    # analize https://www.ipa.go.jp/security/announce/irss/icatw2.js
    def icat4json_url
      "http://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?#{Time.now.to_i}&tool=icatw"
    end
  end

  def self.new(*args, &block)
    ICat4JSON.new(*args, &block)
  end
end
