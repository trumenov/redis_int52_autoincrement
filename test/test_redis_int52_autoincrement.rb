# encoding: UTF-8
# Author:: Andrew Chernuha chaky22222222@gmail.com
# License:: MIT and/or Creative Commons Attribution-ShareAlike
# run test with command: rake

require 'test/unit'
require 'rubygems'
require 'redis_int52_autoincrement'
require "redis"

class TestRedisInt52Autoincrement < Test::Unit::TestCase

  def test_check_generated_placed_in_target_region
    redis = Redis.new(url: "redis://localhost:6379/0")
    left_part = Time.now.to_i << (RedisInt52Autoincrement::MAX_BUFFER_BITS_CNT - RedisInt52Autoincrement::TIMESTAMP_BITS_CNT)
    new_id = RedisInt52Autoincrement.generate(redis)
    right_part = (Time.now.to_i + 1) << (RedisInt52Autoincrement::MAX_BUFFER_BITS_CNT - RedisInt52Autoincrement::TIMESTAMP_BITS_CNT)
    assert new_id.between?(left_part, right_part)
  end
end
