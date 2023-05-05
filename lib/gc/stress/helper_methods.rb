# frozen_string_literal: true

module GC
  module Stress
    # Helper methods for use in tests.
    module HelperMethods
      # Wrap an object and delegate all methods to it, setting `GC.stress = true`
      # before each method call.
      #
      # @param wrapped [Object] the object to wrap
      # @return [Object] the wrapped object
      def gc_stress_object!(wrapped)
        StressedMethodProxy.new(wrapped)
      end
    end
  end
end
