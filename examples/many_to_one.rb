# http://stackoverflow.com/questions/15715605/multiple-goroutines-listening-on-one-channel

require 'channel'

c = Channel.new

1.upto(5) do |i|
  go(lambda do |i, co|
    1.upto(5) do |j|
      co << format('hi from %d.%d', i, j)
    end
  end, i, c)
end

25.times { puts c.recv }
