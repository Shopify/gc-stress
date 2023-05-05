# frozen_string_literal: true

require "gc/stress/version"
require "gc/stress/logging"
require "gc/stress/global_registry"
require "gc/stress/helper_methods"
require "gc/stress/minitest_plugin"
require "gc/stress/patcher"
require "gc/stress/stressed_method_proxy"

# Global GC namespace
module GC
  # Root GC::Stress namespace
  module Stress
    extend self

    # Register a class to be GC.stessed.
    #
    # Under the hood, this will patch the class's `new` to return a
    # `StressedMethodProxy` proxy before each test. When the test is finished,
    # we will restore the original `new` method.
    #
    # @example Registering a class to be GC.stressed
    #   # test/test_helper.rb
    #   require "gc-stress"
    #
    #   GC::Stress.gc_stress_class!(SomeNativeThing) if ENV["GC_STRESS"] == "1"
    #
    #   class Minitest::Test
    #     include GC::Stress::MinitestPlugin
    #   end
    #
    # @param klass [Class] the class to GC.stress
    # @return [void]
    def gc_stress_class!(klass)
      patched = Patcher.patch_new_method!(klass)
      setup, teardown = patched.values_at(:setup, :teardown)
      GlobalRegistry.register_lifecyle_events(setup:, teardown:)
    end
  end
end
