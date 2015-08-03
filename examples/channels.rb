# https://gobyexample.com/channels

require 'channel'

messages = Channel.new

go -> { messages << 'ping' }

msg = messages.recv
puts msg
