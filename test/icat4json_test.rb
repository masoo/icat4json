require "test_helper"

class ICat4JSONTest < Minitest::Test
  FIXTURE_PATH = File.join(__dir__, "fixtures", "icat_response.json")

  def setup
    @fixture = File.read(FIXTURE_PATH, encoding: "UTF-8")
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 200, body: @fixture, headers: {"Content-Type" => "application/json"})
  end

  def test_json_is_parsed
    data = ICat4JSON.new
    assert_instance_of Hash, data.json
    assert_equal "脆弱性対策情報", data.json["docTitle"]
  end

  def test_icat_struct_fields
    data = ICat4JSON.new
    icat = data.icat
    assert_instance_of ICat4JSON::ICat4JSON::ICATData, icat
    assert_equal "脆弱性対策情報", icat.docTitle
    assert_equal "脆弱性対策情報（固定）", icat.docTitleFix
    assert_equal "https://www.ipa.go.jp/security/vuln/icat.html", icat.docLink
    assert_equal "2024-01-15", icat.docDate
  end

  def test_itemdata_is_array
    data = ICat4JSON.new
    assert_instance_of Array, data.icat.itemdata
    assert_equal 2, data.icat.itemdata.length
  end

  def test_itemdata_fields
    data = ICat4JSON.new
    item = data.icat.itemdata.first
    assert_instance_of ICat4JSON::ICat4JSON::ItemData, item
    assert_equal "テスト脆弱性情報1", item.item_title
    assert_equal "https://jvndb.jvn.jp/ja/contents/2024/JVNDB-2024-000001.html", item.item_link
    assert_equal "2024-01-15", item.item_date
    assert_equal "JVNDB-2024-000001", item.item_identifier
  end

  def test_connection_error_on_network_failure
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_raise(SocketError.new("getaddrinfo: Name or service not known"))

    assert_raises(ICat4JSON::ConnectionError) { ICat4JSON.new }
  end

  def test_connection_error_on_timeout
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_raise(Net::OpenTimeout.new("execution expired"))

    assert_raises(ICat4JSON::ConnectionError) { ICat4JSON.new }
  end

  def test_connection_error_on_http_error_status
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 500, body: "Internal Server Error")

    assert_raises(ICat4JSON::ConnectionError) { ICat4JSON.new }
  end

  def test_parse_error_on_invalid_json
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 200, body: "not json", headers: {"Content-Type" => "text/plain"})

    assert_raises(ICat4JSON::ParseError) { ICat4JSON.new }
  end

  def test_error_on_oversized_response
    large_body = "x" * (1_048_576 + 1)
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 200, body: large_body)

    assert_raises(ICat4JSON::Error) { ICat4JSON.new }
  end

  def test_empty_itemdata
    json = JSON.parse(@fixture)
    json["itemdata"] = []
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 200, body: JSON.generate(json))

    data = ICat4JSON.new
    assert_equal [], data.icat.itemdata
  end

  def test_nil_itemdata
    json = JSON.parse(@fixture)
    json.delete("itemdata")
    stub_request(:get, /isec-myjvn-feed1\.ipa\.go\.jp/)
      .to_return(status: 200, body: JSON.generate(json))

    data = ICat4JSON.new
    assert_equal [], data.icat.itemdata
  end

  def test_uses_https
    ICat4JSON.new
    assert_requested(:get, /https:\/\/isec-myjvn-feed1\.ipa\.go\.jp/)
  end
end
