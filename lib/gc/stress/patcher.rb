# frozen_string_literal: true

module GC
  module Stress
    # @private
    class Patcher
      extend Logging

      class << self
        def patch_new_method!(klass)
          log { "Stressing out the #{klass} class" }

          klass.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            class << self
              def stress_test_new(...)
                GC::Stress::StressedMethodProxy.new(stress_test_original_new(...))
              end
            end
          RUBY

          setup = proc do
            klass.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
              class << self
                alias new new # silences warnings, for some reason

                alias_method :stress_test_original_new, :new
                alias_method :new, :stress_test_new
              end
            RUBY
          end

          teardown = proc do
            klass.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
              class << self
                alias_method :new, :stress_test_original_new
              end
            RUBY
          end

          { setup:, teardown: }
        end
      end
    end
  end
end
