# https://gobyexample.com/closing-channels

require 'channel'

jobs = Channel.new(5)
done = Channel.new

go lambda {
  loop do
    begin
      j = jobs.recv
    rescue Channel::Closed
      puts 'received all jobs'
      done << true
      return
    else
      puts "received job #{j}"
    end
  end
}

1.upto 3 do |j|
  jobs << j
  puts "sent job #{j}"
end
jobs.close
puts 'sent all jobs'

done.recv
