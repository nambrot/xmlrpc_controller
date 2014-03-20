# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmlrpc_controller/version'

Gem::Specification.new do |spec|
  spec.name          = "xmlrpc_controller"
  spec.version       = XmlrpcController::VERSION
  spec.authors       = ["Nam Chu Hoai"]
  spec.email         = ["nambrot@googlemail.com"]
  spec.summary       = "Include XMLRPC into any Controller"
  spec.description   = "Utility methods to work with XMLRPC"
  spec.homepage      = "https://github.com/nambrot/xmlrpc_controller"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
