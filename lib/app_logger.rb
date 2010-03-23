require 'redis_logger'
require 'kernel'

#Basis mixin module to provide application logger
module AppLogger
  
  def app_logger
    @app_logger ||= RedisLogger.new('app_log')
  end

  def log_action(message)
    app_logger.app "#{Time.now.strftime("%Y%m%d%H%M")} #{class_name}##{self[:id]}:#{calling_method} #{message}"
  end
  
end
# then extends Model
if defined?(Rails)
 # require "lib/rails/redis_logger"
end