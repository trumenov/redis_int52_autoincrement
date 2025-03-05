# Int64 UUID (UInt52) Autoincremented via Redis

## Why UInt52?

JavaScript has problems with using Int64 values that are less than the maximum UInt54 value. This library ensures a smooth migration to UUID64 without breaking the front end due to JavaScript rounding bugs.

### What bug?

Open your browser console and enter:

```js
11111111111111111 + 2
```

What do you see? Yes, it's `11111111111111114`.

But there's more. Try this:

```js
11111111111111111
```

Press enter. What do you see? Yes, it's `11111111111111112`.

### Why does this happen?

JavaScript uses `Double` to store and work with integers, which leads to precision issues. This is why the maximum integer that JavaScript can process correctly is UInt54.

If you don't want to hunt down and fix all occurrences of this bug in your project but need UUID64, use this library.

## What This Gem Provides

Generates universally unique identifiers (UUID52) with unsigned Int64 last 52 bits (so it will be UInt52) for use in distributed applications.

### Based on:

1. The ability to auto-increment values in Redis.
2. Unix timestamps with microseconds.
3. The ability to expire keys in the Redis database.
4. Ensuring UInt52 values can be used in JavaScript without precision issues.

## Generating UInt52 IDs

Call `#generate` to generate a new UUID64. The method returns a unique Int64 value less than the maximum UInt52 value.

### Example in Rails:

Add into your Gemfile:
```ruby
gem 'redis_int52_autoincrement'
```

```ruby
before_create do |record|
  record.id ||= RedisInt52Autoincrement.generate(Rails.cache.redis || Redis.new(url: "redis://localhost:6379/0"))
end
```

## Why So Complex?

A common issue is that servers may have different time settings. During time synchronization, there can be a shift of a few seconds. This library accounts for a maximum delta shift of ±50 (`UUID52_MAX_SECONDS_EXPIRE`) seconds.

## Latest and Greatest

Source code and documentation are hosted on GitHub:

[GitHub Repository](http://github.com/trumenov/redis_int52_autoincrement)

To get UUID52 from the source:

```sh
git clone git://github.com/trumenov/redis_int52_autoincrement.git
```

## License

This package is licensed under the MIT License and/or the Creative Commons Attribution-ShareAlike.

See MIT-LICENSE for details.

## Run tests

```sh
rake test
```
