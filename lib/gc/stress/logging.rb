# frozen_string_literal: true

module GC
  module Stress
    # @private
    module Logging
      extend self

      def log(&block)
        return unless ENV["GC_STRESS_DEBUG"]

        msg = block.call
        warn("\n[GC::Stress] #{msg}")
      end
    end
  end
end
