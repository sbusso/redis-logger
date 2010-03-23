# Extends Kernel to get the class and method names
module Kernel
private
  def method_name
    caller[0][/`([^']*)'/, 1]
  end
  def calling_method
    caller[1][/`([^']*)'/, 1]
  end
  
  def class_name
    self.class.to_s.split('::').last.downcase
  end  
end