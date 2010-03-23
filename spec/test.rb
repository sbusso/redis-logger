$: << File.join(File.dirname(__FILE__), "/../lib")
require 'app_logger'
require 'redis_logger_reader'
# Test modules and classes
module Foo
  attr_reader :id
  class Test
    include AppLogger
    @@incr = 0

    def initialize
      @id = @@incr += 1
    end
    
    def [](var)
      return self.send(var)
    end
  
    def joli
      log_action "hello"
    end
  
  end

  class Re < Test
  end
end

# Run test
#RedisLogger.flush
RedisLogger.new('app_log', 'DEBUG', 'localhost:6379').clear #|| RedisLogger.new('app_log')
re = Foo::Test.new
re.joli
re = Foo::Re.new
re.joli
#RedisLogger.list
RedisLoggerReader.list('app_log')

log_name = 'test_redis_log'
rl = RedisLogger.new(log_name)
rl.clear
# test insertion message, retrieve
# test niveau des messages
