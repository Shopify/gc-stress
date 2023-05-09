# frozen_string_literal: true

require "bundler/setup"
require "maxitest/autorun"
require "gc-stress"
require "pry"

class SomeNativeThing
  class << self
    def some_class_method
      "foo"
    end
  end
end

GC::Stress.configure do |c|
  c.stressed_classes = [SomeNativeThing]
  c.enabled = true
end

module Minitest
  class Test
    class << self
      def test(name, &block)
        define_method("test_#{name.gsub(/\s+/, "_")}", &block)
      end
    end
  end
end
