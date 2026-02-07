lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "icat4json/version"

Gem::Specification.new do |spec|
  spec.name = "icat4json"
  spec.version = ICat4JSON::VERSION
  spec.authors = ["FUNABARA Masao"]
  spec.email = ["masao@masoo.jp"]
  spec.summary = "Ruby client for IPA's icat for JSON vulnerability feed"
  spec.description = "A Ruby gem to fetch and parse vulnerability information from IPA's icat for JSON feed. Provides easy access to Japanese vulnerability database."
  spec.homepage = "https://github.com/masoo/icat4json"
  spec.license = "MIT"
  spec.files = Dir.glob("{lib}/**/*").push(
    "LICENSE.txt", "README.md", "icat4json.gemspec"
  ).select { |f| File.file?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "irb"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
