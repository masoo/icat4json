require "icat4json/version"
require "net/http"
require "uri"
require "json"

module ICat4JSON
  class ICat4JSON
    attr_accessor :json, :icat
    ICAT4JSON_URL = "http://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?1456207434&tool=icatw"

    def initialize
      uri = URI.parse(ICAT4JSON_URL)
      http = Net::HTTP.get(uri)
      @json = JSON.parse(http)
      struct_icat = Struct.new(:itemdata, :docTitle, :docTitleFix, :docLink, :docDate)
      struct_item = Struct.new(:item_title, :item_link, :item_date, :item_identifier)
      @icat = struct_icat.new
      @json.each {|k, v| icat[k] = v unless k == "itemdata" }
      @icat[:itemdata] = []
      @json["itemdata"].each do |itemdata|
        item = struct_item.new
        itemdata.each do |k,v|
          item[k] = v
        end
        @icat[:itemdata].push item
      end
      true
    end
  end
end
