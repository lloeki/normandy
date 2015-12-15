# https://gobyexample.com/range-over-channels

require 'channel'

queue = Channel.new(2)
queue << 'one'
queue << 'two'
queue.close

queue.each { |e| puts e }
