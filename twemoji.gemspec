# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twemoji/version'

Gem::Specification.new do |spec|
  spec.name          = "twemoji"
  spec.version       = Twemoji::VERSION
  spec.authors       = %w(Juanito Fatas)
  spec.email         = %w(katehuang0320@gmail.com)
  spec.summary       = %(A RubyGem to convert :heart: to Twitter cdn url)
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/jollygoodcode/twemoji"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = %w(lib)

  spec.required_ruby_version = "~> 2.0"

  spec.add_dependency "nokogiri", "~> 1.6.2"
end
