# http://stackoverflow.com/questions/15715605/multiple-goroutines-listening-on-one-channel

require 'channel'
require 'channel/waitgroup'

c = Channel.new
w = WaitGroup.new
w.add(5)

1.upto(5) do |i|
  go(lambda { |i, ci|
      j = 1
      ci.each { |v|
        sleep(0.001)
        puts format("%d.%d got %d", i, j, v)
        j += 1
      }
      w.done
  }, i, c)
end

1.upto(25) { |i| c << i }
c.close
w.wait
