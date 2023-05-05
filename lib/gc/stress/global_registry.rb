# frozen_string_literal: true

module GC
  module Stress
    # @private
    class GlobalRegistry
      @stressed_classes = []

      class << self
        def register_lifecyle_events(setup:, teardown:)
          @stressed_classes << [setup, teardown]
        end

        def setup!
          @stressed_classes.each { |setup, _| setup.call }
          true
        end

        def teardown!
          @stressed_classes.each { |_, teardown| teardown.call }
          true
        end
      end
    end
  end
end
