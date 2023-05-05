# frozen_string_literal: true

module GC
  module Stress
    # Configuration for GC::Stress
    class Configuration
      include Logging

      def initialize
        @enabled = ENV["GC_STRESS"] == "true" || ENV["GC_STRESS"] == "1"
        @stressed_classes = []
      end

      # A list of classes that should be GC stressed.
      #
      # @example Configure stressed classes
      #    GC::Stress.configure do |config|
      #      config.stressed_classes = [MyClass, MyOtherClass]
      #    end
      #
      # @return [Configuration]
      attr_accessor :stressed_classes

      # Enable GC stress mode.
      #
      # @example Enable GC stress mode
      #   GC::Stress.configure do |config|
      #     config.enabled = true # Defaults to ENV["GC_STRESS"] == "true" || ENV["GC_STRESS"] == "1"
      #   end
      attr_accessor :enabled

      # @private
      def apply!
        return unless enabled

        stressed_classes.each do |klass|
          GC::Stress.gc_stress_class!(klass)
        end

        if defined?(Minitest::Test)
          log { "Including MinitestPlugin" }
          Minitest::Test.include(MinitestPlugin)
        end
      end
    end
  end
end
