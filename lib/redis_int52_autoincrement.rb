class RedisInt52Autoincrement

  # Why 30 seconds? Easy to debug and more than enouth for sync time delta shift.
  # You can use 10 or 5 seconds - and all must working normal too.
  # 30seconds was chosen by me without any explanation. Just took this value, i do not know why.
  REDIS_KEY_TTL_SECONDS = 30

  MAX_BUFFER_BITS_CNT = 52
  TIMESTAMP_BITS_CNT = 34.freeze # 34bits for 150+ years more than enougth
  TIMESTAMP_MICROSECONDS_BITS_CNT = 20.freeze # 0..999_999 - require 20bits
  TIMESTAMP_MICROSECONDS_STORE_BITS_CNT = 9.freeze # from max value 999_999 we will take only first 9 high bits.
  TIMESTAMP_MICROSECONDS_BITS_SHL = TIMESTAMP_MICROSECONDS_BITS_CNT - TIMESTAMP_MICROSECONDS_STORE_BITS_CNT
  INCREMENTED_ID_BITS_CNT = 7.freeze  # 7bits for 0..127 INCREMENTED_UINT8_ID
  SERVER_ID_BITS_CNT = 2.freeze
  # So in result: 34 + 9 + 7 + 2 = 52bits(MAX_BUFFER_BITS_CNT).

  TIMESTAMP_SECONDS_SHIFT_LEFT_CNT = (TIMESTAMP_MICROSECONDS_STORE_BITS_CNT + INCREMENTED_ID_BITS_CNT + SERVER_ID_BITS_CNT).freeze # 18 bits
  TIMESTAMP_MICROSECONDS_SHIFT_LEFT_CNT = (INCREMENTED_ID_BITS_CNT + SERVER_ID_BITS_CNT).freeze # 9 bits
  INCREMENTED_ID_MAX_VAL    = ((1 << INCREMENTED_ID_BITS_CNT) - 1).freeze # 1111111b=127
  UINT52_MAX_VAL = 4503599627370496 # 2^52 = 4503599627370496
  LIB_FIRST_VAL  = 447450850315268 # First id was generated 02.02.2024 at ~18:00 (Kiev +2:00)

  # Version number.
  module Version
    version = Gem::Specification.load(File.expand_path("../redis_int52_autoincrement.gemspec", File.dirname(__FILE__))).version.to_s.split(".").map { |i| i.to_i }
    MAJOR = version[1]
    MINOR = version[0]
    PATCH = version[1]
    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}"
  end

  VERSION = Version::STRING

  class << self
    def generate(redis, namespace = 'default', options = {})
      server_id = options[:server_id] || 0
      time_redis = options[:time_redis] || redis
      raise("Wrong server_id[#{server_id}]. Allow only 0..3 server_id") unless server_id.between?(0, 3)
      time_arr = time_redis.time
      raise("Wrong time type[#{time_arr.inspect}]") unless time_arr.count.eql?(2)
      unix_seconds = time_arr.first.to_i
      first_part = unix_seconds << TIMESTAMP_SECONDS_SHIFT_LEFT_CNT

      microseconds = time_arr[1].to_i
      raise("Wrong microseconds [#{microseconds}]") unless microseconds.between?(0, 999_999)
      second_part = (microseconds >> TIMESTAMP_MICROSECONDS_BITS_SHL) << TIMESTAMP_MICROSECONDS_SHIFT_LEFT_CNT

      key = "ai64:#{namespace}:#{unix_seconds}:#{microseconds}"
      incremented_val = redis.incrby(key, 1)
      redis.expire(key, REDIS_KEY_TTL_SECONDS)
      raise("Wrong incremented_val [#{incremented_val}]") unless incremented_val.between?(0, INCREMENTED_ID_MAX_VAL)
      third_part = incremented_val << SERVER_ID_BITS_CNT
      result = ((first_part | second_part) | third_part) | server_id
      raise("Wrong result[#{result}]") unless result.between?(LIB_FIRST_VAL, UINT52_MAX_VAL)
      result
    end
  end
end
