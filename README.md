# `gc-stress`

[![License: MIT][mit-badge]][mit]

`gc-stress` is a Ruby gem that provides targeted and efficient garbage
collection (GC) stress testing for your native extensions. The primary goal of
this gem is to ensure GC safety for your native structs and classes.

## Why?

If you are writing native extensions for Ruby, you need to ensure that your code
is GC safe. This means all handles to Ruby objects are either:

- Directly on the machine stack or in CPU registers
- Heap allocated objects are marked so they are not collected by the GC

With modern optimizing compilers, it's easy to have unsafe code that looks safe,
works at `-O1` and `-O2`, but breaks at `-O3`. This is because the compiler can
optimize away the stack and register references to Ruby objects, and the GC will
collect them. So you absolutely need to GC stress test your native extensions.

### Why not just set `GC.stress = true` globally?

You absolute can. However, this approach has a major drawback: **it's
slowwwww**, because you are stress testing the entire Ruby VM. In fact, you may
actually trigger bugs in dependencies that are not GC safe, and not even related
to your native extension!

`gc-stress` provides a more targeted approach to GC stress testing. You pick
specific classes to stress test, and `gc-stress` will wrap only those classes,
and only for the duration of the test. This approach is much more efficient, and
makes running GC stress tests in CI much more feasible.

## Usage

After installing the `gc-stress` gem, you can use its provided helpers to stress
test your native extensions and ensure their GC safety.

### With `Minitest`

```ruby
# test/test_helper.rb

require "minitest/autorun"
require "gc-stress"

class MiniTest::Test
  include GC::Stress::MinitestPlugin
end

GC::Stress.gc_stress_class!(MyNativeClass)
```

### Standalone

```ruby
stressed_object = GC::Stress.gc_stress_object!(MyNativeClass.new)
stressed_object.do_something # will set GC.stress = true during the call
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gc-stress'
```

And then execute:

```sh
$ bundle install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [Shopify/gc-stress][repo].

## License

The gem is available as open-source under the terms of the [MIT License][mit].

## Credits

`gc-stress` is developed and maintained by Shopify Inc.

[mit]: https://opensource.org/licenses/MIT
[mit-badge]: https://img.shields.io/badge/License-MIT-green.svg
[repo]: https://github.com/Shopify/gc-stress.
