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
              alias new new # silences warnings, for some reason

              alias_method :stress_test_original_new, :new

              def stress_test_new(...)
                GC::Stress::StressedMethodProxy.new(stress_test_original_new(...))
              end
            end
          RUBY

          setup = proc do
            klass.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
              class << self
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

        def patch_class_methods!(klass)
          log { "Stressing out the #{klass} class methods" }
          class_methods = klass.methods(false).map(&:to_sym)
          class_methods -= [:allocate, :new]
          class_methods.reject! { |method| method.to_s.start_with?("stress_test_") }

          class_methods.map do |method|
            klass.singleton_class.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
              alias_method :stress_test_original_#{method}, :#{method}

              def stress_test_#{method}(...)
                GC.stress = true
                GC::Stress::Logging.log { "Stressing out #{self}.#{method}" }
                stress_test_original_#{method}(...)
              ensure
                GC.stress = false
              end
            RUBY

            setup = proc do
              klass.singleton_class.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
                alias_method :#{method}, :stress_test_#{method}
              RUBY
            end

            teardown = proc do
              klass.singleton_class.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
                alias_method :#{method}, :stress_test_original_#{method}
              RUBY
            end

            { setup:, teardown: }
          end
        end
      end
    end
  end
end
