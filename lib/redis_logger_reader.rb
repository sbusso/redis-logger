# basic redis logger reader
class RedisLoggerReader
  def self.list(logkey, limit = 0)
   redis.list_range(logkey, 0, limit-1).each { |log|
      p log.scan(/^(\d+)\s(\w+)#(\d*):(\w+)\s(.*)/).first.pack("A13A12A5A20A50")
    }
  end
  
  def self.count(logkey)
    # redis
  end
  
  private
  
  def self.redis
    @@redis ||= Redis.new
  end
  
end