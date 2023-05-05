# frozen_string_literal: true

module GC
  module Stress
    # Wraps a class and delegates all methods to it, but sets GC.stress = true
    # before each method call.
    #
    # @private
    class StressedMethodProxy
      include Logging

      def initialize(wrapped)
        @wrapped = wrapped
      end

      def method_missing(...)
        log { "Stressing out #{@wrapped}" }
        GC.stress = true
        @wrapped.send(...)
      ensure
        GC.stress = false
      end

      def respond_to_missing?(method, include_private = false)
        @wrapped.respond_to?(method, include_private)
      end
    end
  end
end
