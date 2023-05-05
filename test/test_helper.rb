# frozen_string_literal: true

require "bundler/setup"
require "maxitest/autorun"
require "gc-stress"

module Minitest
  class Test
    include GC::Stress::HelperMethods

    class << self
      def test(name, &block)
        define_method("test_#{name.gsub(/\s+/, "_")}", &block)
      end
    end
  end
end
