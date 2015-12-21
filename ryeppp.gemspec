# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ryeppp/version'

Gem::Specification.new do |spec|
  spec.name          = "ryeppp"
  spec.version       = Ryeppp::VERSION
  spec.authors       = ["Brad Cater"]
  spec.email         = ["bradcater@gmail.com"]
  spec.description   = %q{This gem provides bindings to the Yeppp! library. According to the documentation, "Yeppp! is a high-performance SIMD-optimized mathematical library for x86, ARM, and MIPS processors on Windows, Android, Mac OS X, and GNU/Linux systems."}
  spec.summary       = %q{This gem provides bindings to the Yeppp! library.}
  spec.homepage      = "https://github.com/bradcater/ruby-yeppp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extensions << "ext/ryeppp/extconf.rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rake", ">= 1.9.1"
  spec.add_development_dependency "rspec", ">= 2.13.0"
  spec.add_development_dependency "RubyInline", "~> 3.12.2"
  spec.add_development_dependency "trollop", "~> 2.0"
  spec.add_development_dependency "version_bumper", "~> 0.3.0"
end
