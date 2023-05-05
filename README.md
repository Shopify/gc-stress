# `gc-stress`

[![License: MIT][mit-badge]][mit]

`gc-stress` is a Ruby gem that provides targeted and efficient garbage
collection (GC) stress testing for your native extensions. The primary goal of
this gem is to ensure GC safety for your native structs and classes.

## Features
- Helpers to stress test your native extensions GC safety.
- Targeted and efficient GC stress testing for native structs and classes.
- Requires Ruby version 3.2.0 or higher.

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
