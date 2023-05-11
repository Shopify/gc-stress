# frozen_string_literal: true

require_relative "lib/gc/stress/version"

Gem::Specification.new do |s|
  s.name        = "gc-stress"
  s.version     = GC::Stress::VERSION
  s.licenses    = ["MIT"]
  s.summary     = "Helpers to stress test your native extensions GC safety."
  s.description = "Provides targeted, efficient GC.stress testing for your native structs and classes"
  s.authors     = ["Shopify Inc."]
  s.email       = "gems@shopify.com"
  s.files       = Dir["lib/**/*.rb"]
  s.homepage    = "https://github.com/Shopify/gc-stress"
  s.metadata    = { "source_code_uri" => s.homepage }
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3.0.0"
end
