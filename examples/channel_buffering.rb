# https://gobyexample.com/channel_buffering

require 'channel'

messages = Channel.new(2)

messages << 'buffered'
messages << 'channel'

puts messages.recv
puts messages.recv
