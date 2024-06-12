$redis_onlines =
  if Rails.env.test?
    require 'mock_redis'
    MockRedis.new
  else
    Redis.new
  end