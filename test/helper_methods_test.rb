# frozen_string_literal: true

require_relative "test_helper"

class HelperMethodsTest < Minitest::Test
  def test_gc_stress_object
    some_native_klass = Class.new do
      attr_reader :name, :stressed

      def initialize(name)
        @name = name
        @stressed = false
      end

      def do_something
        @stressed = GC.stress
      end
    end

    obj = some_native_klass.new("foo")
    obj.do_something
    refute(obj.stressed, "should not be stressed at first")

    wrapped = gc_stress_object!(obj)
    wrapped.do_something
    assert(wrapped.stressed, "should be stressed wrapping")
  end
end
