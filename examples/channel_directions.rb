# https://gobyexample.com/channel-directions

require 'channel'

def ping(pings, msg)
  pings << msg
end

def pong(pings, pongs)
  msg = pings.recv
  pongs << msg
end

pings = Channel.new(1)
pongs = Channel.new(1)
ping(pings, 'passed message')
pong(pings, pongs)
puts pongs.recv
