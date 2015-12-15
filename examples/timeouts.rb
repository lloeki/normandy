# https://gobyexample.com/timeouts

require 'channel'
require 'channel/timer'

c1 = Channel.new(1)
go lambda {
  sleep(2)
  c1 << 'result 1'
}

Channel.select(c1, t1 = Channel::Timer.after(1)) do |res, c|
  case c
  when c1 then puts res
  when t1 then puts 'timeout 1'
  end
end

c2 = Channel.new(1)
go lambda {
  sleep(2)
  c2 << 'result 2'
}

Channel.select(c2, t2 = Channel::Timer.after(3)) do |res, c|
  case c
  when c2 then puts res
  when t2 then puts 'timeout 1'
  end
end
