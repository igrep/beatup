# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beatup'

Gem::Specification.new do |spec|
  spec.name          = "beatup"
  spec.version       = Beatup::VERSION
  spec.authors       = ["Yamamoto Yuji"]
  spec.email         = ["whosekiteneverfly@gmail.com"]
  spec.summary       = %q{Observer extension for class.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/igrep/beatup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'test-unit', '~> 3.0'
  spec.add_development_dependency 'crispy', '>= 0.4.0'
end
