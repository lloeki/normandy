class Channel::Timer
  attr_reader :channel

  def initialize(delay)
    @channel = Channel.new(1)
    @prc = -> { sleep delay; channel << Time.now }
    start
  end

  def start
    Channel::Runtime.go @prc
  end

  def self.after(delay)
    new(delay).channel
  end
end
