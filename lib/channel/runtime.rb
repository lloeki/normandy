require 'thread'

module Channel::Runtime
  module_function

  def go(prc, *args)
    Thread.new { prc.call(*args) }
  end
end

module Kernel
  def go(prc, *args)
    Channel::Runtime.go(prc, *args)
  end
end
