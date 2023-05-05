# frozen_string_literal: true

module GC
  module Stress
    # Include this module in your `Minitest::Test` to manage GC.stressing for you.
    #
    # @example
    #  class MyTest < Minitest::Test
    #    include StressTest::MinitestPlugin
    #
    #    def test_something
    #      stressed_object = gc_stress_object!(SomeNativeThing.new)
    #      stressed_object.do_something
    #
    #      assert(true, "should not segfault")
    #    end
    #  end
    module MinitestPlugin
      class << self
        # @private
        def included(klass)
          super
          klass.include(HelperMethods)
        end
      end

      # @private
      def before_setup
        begin
          super
        rescue
          nil
        end
        GC::Stress::GlobalRegistry.setup!
      end

      # @private
      def after_teardown
        begin
          super
        rescue
          nil
        end
        GC::Stress::GlobalRegistry.teardown!
      end
    end
  end
end
