# frozen_string_literal: true

require_relative "test_helper"

class MinitestPluginTest < Minitest::Test
  test "the truth" do
    assert_equal("0.1.0", GC::Stress::VERSION)
  end

  test "the lifecyle events are registered" do
    under_stress = false
    subject = Class.new
    subject.define_method(:foo) do
      under_stress = GC.stress
    end
    GC::Stress.gc_stress_class!(subject)

    fake_minitest = Class.new do
      include GC::Stress::MinitestPlugin
    end.new

    fake_minitest.before_setup
    subject.new.foo
    assert(under_stress, "GC.stress should be true")
    fake_minitest.after_teardown

    subject.new.foo
    refute(under_stress, "GC.stress should be false")
  end

  test "global objects returned proxied objects when new is called" do
    obj = SomeNativeThing.new

    assert(obj.is_a?(SomeNativeThing))
    assert(obj.inspect.start_with?("StressedMethodProxy("))
  end

  test "global objects class methods are patched" do
    assert_equal(SomeNativeThing.method(:stress_test_some_class_method), SomeNativeThing.method(:some_class_method))
    refute_equal(
      SomeNativeThing.method(:stress_test_original_some_class_method),
      SomeNativeThing.method(:some_class_method),
    )

    assert_equal("foo", SomeNativeThing.some_class_method)
  end
end
