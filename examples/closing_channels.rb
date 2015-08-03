# https://gobyexample.com/closing-channels

require 'channel'

jobs = Channel.new(5)
done = Channel.new

go lambda {
  loop do
    begin
      j = jobs.recv
    rescue Channel::Closed
      # TODO: wrong! ends before all items recv'd
      # j, more := <-jobs; more == True
      puts 'received all jobs'
      done << true
      return
    else
      puts "received job #{j}"
    end
  end
}

3.times do |j|
  jobs << j
  puts "sent job #{j}"
end
jobs.close
puts 'sent all jobs'

done.recv
