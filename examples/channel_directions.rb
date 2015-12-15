# https://gobyexample.com/channel-directions

require 'channel'

def ping(pings, msg)
  pings = pings.send_only!
  pings << msg
end

def pong(pings, pongs)
  pings = pings.receive_only!
  pongs = pongs.send_only!
  msg = pings.recv
  pongs << msg
end

pings = Channel.new(1)
pongs = Channel.new(1)
ping(pings, 'passed message')
pong(pings, pongs)
puts pongs.recv
