# https://gobyexample.com/select

require 'channel'

c1 = Channel.new
c2 = Channel.new

go lambda {
  sleep(1)
  c1 << 'one'
}

go lambda {
  sleep(2)
  c2 << 'two'
}

2.times do
  Channel.select(c1, c2) do |msg, c|
    case c
    when c1 then puts "received #{msg}"
    when c2 then puts "received #{msg}"
    end
  end
end
