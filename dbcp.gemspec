# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbcp/version'

Gem::Specification.new do |spec|
  spec.name          = "dbcp"
  spec.version       = Dbcp::VERSION
  spec.authors       = ["Gabe Martin-Dempesy"]
  spec.email         = ["gabetax@gmail.com"]
  spec.description   = %q{Copy SQL databases between application environments}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/gabetax/dbcp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", "~> 1.0.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
