
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "icat4json/version"

Gem::Specification.new do |spec|
  spec.name          = "icat4json"
  spec.version       = Icat4json::VERSION
  spec.authors       = ["FUNABARA Masao"]
  spec.email         = ["masao@masoo.jp"]

  spec.summary       = "IPA's \"icat for JSON\" ruby package"
  spec.description   = "IPA's \"icat for JSON\" ruby package"
  spec.homepage      = "https://github.com/masoo/icat4json"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
