#redis_logger.rb
require 'rubygems'
require 'redis'
require 'redis/namespace'
# require 'redis-store' # redis factory 
# require "redis/redis_factory"
# require "redis/marshaled_redis"
# require "redis/distributed_marshaled_redis"

# Class to provide redis logger
class RedisLogger
  
  module Severity
    DEBUG   = 0
    INFO    = 1
    WARN    = 2
    ERROR   = 3
    FATAL   = 4
    UNKNOWN = 5
    APP     = 6
  end
  include Severity
  
  attr_accessor :level
  
  def initialize(log, level = DEBUG, *addresses)
    @level  = level
    @@log   = log
    @redis = RedisLogger.create(addresses)
  end

  def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      # If a newline is necessary then create a new message ending with a newline.
      # Ensures that the original message is not mutated.
      message = "#{message}\n" unless message[-1] == ?\n
      redis.push_tail @@log, message
      message
  end
    
  for severity in Severity.constants
        class_eval <<-EOT, __FILE__, __LINE__ + 1
          def #{severity.downcase}(message = nil, progname = nil, &block) # def debug(message = nil, progname = nil, &block)
            add(#{severity}, message, progname, &block)                   #   add(DEBUG, message, progname, &block)
          end                                                             # end
  
          def #{severity.downcase}?                                       # def debug?
            #{severity} >= @level                                         #   DEBUG >= @level
          end                                                             # end
        EOT
      end
  
  def clear
    redis.delete @@log
  end
  
  # straight up lifted from redisk from ... from @defunkt's resque
  # Accepts a 'hostname:port' string or a Redis server.
  # def redis=(server)
  #   case server
  #   when String
  #     host, port = server.split(':')
  #     redis = Redis.new(:host => host, :port => port, :thread_safe => true)
  #     @redis = Redis::Namespace.new(:redis_logger, :redis => redis)
  #   when Redis
  #     @redis = Redis::Namespace.new(:redis_logger, :redis => server)
  #   else
  #     raise "I don't know what to do with #{server.inspect}"
  #   end
  # end

  # Returns the current Redis connection. If none has been created, will
  # create a new one.
  def redis
    return @redis ||= self.create
  end
  
  # from RedisFactory - redis-store @jodosha
  class << self
    def create(*addresses)
      addresses = extract_addresses(addresses)
      if addresses.size > 1
        Redis.new addresses
      else
        Redis.new addresses.first || {}
      end
    end
    
    private
      def extract_addresses(addresses)
        addresses = addresses.flatten.compact
        addresses.inject([]) do |result, address|
          host, port = address.split /\:/
          port, db   = port.split /\// if port
          address = {}
          address[:host] = host if host
          address[:port] = port if port
          address[:db]  = db.to_i if db
          result << address
          result
        end
      end
  end
  
  # def initialize(*addresses)
  #   @data = RedisFactory.create(addresses)
  # end
  
  
end
