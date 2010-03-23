require 'rubygems'  
require 'rake'  
require 'echoe'  
  
Echoe.new('redis-logger', '0.1.0') do |p|  
  p.description     = "A logger based on redis to use with Rails or to log your method actions"  
  p.url             = "http://github.com/sbusso/redis-logger"  
  p.author          = "Stephane Busso"  
  p.email           = "stephane.busso@gmail.com"  
  p.ignore_pattern  = ["tmp/*", "script/*"]  
  p.development_dependencies = []  
end  
  
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }