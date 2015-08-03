# https://gobyexample.com/range-over-channels

require 'channel'

queue = Channel.new(2)
queue << 'one'
queue << 'two'
close(queue)

queue.each { |e| puts e }
