
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dss_reuters/version"

Gem::Specification.new do |spec|
  spec.name          = "dss_reuters"
  spec.version       = DssReuters::VERSION
  spec.authors       = ["Arda Karaduman"]
  spec.email         = ["akaraduman@gmail.com"]

  spec.summary       = %q{This is a simple gem to extract data from DSS Reuters}
  spec.description   = %q{This is a simple gem to extract data from DSS Reuters}
  spec.homepage      = "https://github.com/c0ze/dss_reuters"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5.1"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4"
  spec.add_dependency "httparty", "~> 0.16"
  spec.add_dependency "pry-byebug"
  spec.add_dependency "dotenv"
end
