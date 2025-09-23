
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "icat4json/version"

Gem::Specification.new do |spec|
  spec.name          = "icat4json"
  spec.version       = Icat4json::VERSION
  spec.authors       = ["FUNABARA Masao"]
  spec.email         = ["masao@masoo.jp"]
  spec.summary       = "Ruby client for IPA's icat for JSON vulnerability feed"
  spec.description   = "A Ruby gem to fetch and parse vulnerability information from IPA's icat for JSON feed. Provides easy access to Japanese vulnerability database."
  spec.homepage      = "https://github.com/masoo/icat4json"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.7.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
