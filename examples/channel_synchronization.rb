# https://gobyexample.com/channel-synchronization

require 'channel'

def worker(done)
  puts 'working...'
  sleep 1
  puts 'done'
  done << true
end

done = Channel.new(1)
go -> { worker(done) }

done.recv
