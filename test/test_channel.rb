require 'test/unit'
require 'thread'
require 'channel'

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength

class TestChannel < Test::Unit::TestCase
  module Util
    def meanwhile(*procs, &blk)
      threads = procs.map { |p| Thread.new(&p) }
      blk.call
      threads.each(&:join)
    end
  end

  module Assert
    def assert_raise_with_message(exc, msg, &block)
      e = assert_raise(exc, &block)
      assert_match(msg, e.message)
    end
  end

  include Util
  include Assert

  def test_channel
    c = Channel.new
    result = nil
    meanwhile(-> { result = c.recv }) do
      c << 'foo'
    end
    assert_equal('foo', result)
  end

  def test_closed_channel
    c = Channel.new
    c.close
    assert_equal(true, c.closed?)
    assert_raise(Channel::Closed) { c.recv }
  end

  def test_buffered_channel
    messages = Channel.new(2)

    messages << 'buffered'
    messages << 'channel'

    assert_equal('buffered', messages.recv)
    assert_equal('channel',  messages.recv)
  end

  # def test_fail_send_to_unbuffered_channel
  #   c = Channel.new
  #   assert_raise_with_message(ThreadError, /No live threads left/) do
  #     c.send 'foo'
  #   end
  # end

  def test_send_to_unbuffered_channel
    c = Channel.new
    go -> { assert_equal('foo', c.recv) }
    c.send 'foo'
  end

  # def test_fill_buffered_channel
  #   c = Channel.new(1)
  #   c.send 'foo'
  #   assert_raise_with_message('ThreadError', /No live threads left/) do
  #     c.send 'foo'
  #   end
  # end

  def test_single_thread_send_to_buffered_channel
    c = Channel.new(1)
    c.send 'foo'
    assert_equal('foo', c.recv)
  end

  def test_send_on_closed_channel
    c = Channel.new
    c.close
    assert_raise(Channel::Closed) { c << 'foo' }
  end

  def test_receive_on_closed_blocking_channel
    c = Channel.new
    meanwhile(-> { assert_raise(Channel::Closed) { c.recv } }) do
      sleep(0.1)
      c.close
    end
    assert_equal(true, c.closed?)
  end

  def test_many_receive_on_closed_blocking_channel
    c = Channel.new
    meanwhile(
      -> { assert_raise(Channel::Closed) { c.recv } },
      -> { assert_raise(Channel::Closed) { c.recv } },
      -> { assert_raise(Channel::Closed) { c.recv } },
    ) do
      sleep(0.1)
      c.close
    end
    assert_equal(true, c.closed?)
  end

  def test_receive_and_close_buffered_channel
    c = Channel.new(5)
    meanwhile(
      -> { sleep 0.1; assert_equal(1, c.recv) },
      -> { sleep 0.2; assert_equal(2, c.recv) },
      -> { sleep 0.3; assert_equal(3, c.recv) },
      -> { sleep 0.4; assert_raise(Channel::Closed) { c.recv } },
    ) do
      c << 1
      c << 2
      c << 3
      c.close
    end
    assert_equal(true, c.closed?)
  end

  def test_iterate_over_buffered_channel
    c = Channel.new(2)
    c << 1
    c << 2
    c.close

    assert_equal([1, 2], c.each.to_a)
  end

  # def test_iterate_over_unclosed_buffered_channel
  #   c = Channel.new(2)
  #   c << 1
  #   c << 2

  #   assert_raise_with_message('ThreadError', /No live threads left/) do
  #     c.each.to_a
  #   end
  # end

  def test_select
    c1 = Channel.new
    c2 = Channel.new
    c3 = Channel.new
    c4 = Channel.new

    go -> { sleep(0.1); c1 << '1' }
    go -> { sleep(0.2); c2 << '2' }
    go -> { sleep(0.3); c3 << '3' }
    go -> { sleep(0.4); c4 << '4' }

    4.times do
      Channel.select(c1, c2, c3, c4) do |msg, c|
        case c
        when c1 then assert_equal('1', msg)
        when c2 then assert_equal('2', msg)
        when c3 then assert_equal('3', msg)
        when c4 then assert_equal('4', msg)
        end
      end
    end
  end
end
