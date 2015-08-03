require 'thread'

module Kernel
  def go(prc, *args)
    Thread.new { prc.call(*args) }
  end
end

class Channel
  class Closed < StandardError; end

  def initialize(size = nil)
    @q = size ? SizedQueue.new(size) : Queue.new
    @closed = false
    @mutex = Mutex.new
    @waiting = []
  end

  private def lock!(&block)
    @mutex.synchronize(&block)
  end

  private def wait!
    @waiting << Thread.current
    @mutex.sleep
  end

  private def next!
    loop do
      thr = @waiting.shift
      break if thr.nil?
      next unless thr.alive?
      break thr.wakeup
    end
  end

  private def all!
    @waiting.dup.each { next! }
  end

  def recv
    lock! do
      loop do
        closed! if closed?
        wait! && next if @q.empty?
        break @q.pop
      end
    end
  end
  alias_method :pop, :recv

  def send(val)
    lock! do
      fail Closed if closed?
      @q << val
      next!
    end
  end
  alias_method :push, :send
  alias_method :<<, :push

  def close
    lock! do
      return if closed?
      @closed = true
      all!
    end
  end

  def closed?
    @closed
  end

  private def closed!
    fail Closed
  end

  class << self
    def select(*channels)
      selector = new
      threads = channels.map do |c|
        Thread.new { selector << [c.recv, c] }
      end
      yield selector.recv
    ensure
      selector.close
      threads.each(&:kill).each(&:join)
    end
  end
end
