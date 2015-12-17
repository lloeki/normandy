require 'test/unit'
require 'thread'
require 'channel/waitgroup'

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

class TestWaitGroup < Test::Unit::TestCase
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

  def test_waitgroup
    Time.now.tap do |start|
      wg = WaitGroup.new
      wg.add(2)
      ok1 = false
      ok2 = false
      go -> { sleep 0.3; ok1 = true; wg.done }
      go -> { sleep 0.5; ok2 = true; wg.done }
      wg.wait
      duration = Time.now - start
      assert_equal(true, duration > 0.48)
      assert_equal(true, duration < 0.52)
      assert_true(ok1)
      assert_true(ok2)
      assert_raises(RuntimeError) { wg.done }
    end
  end

  def test_waitgroup_concurrent_add
    wg = WaitGroup.new
    go -> { wg.wait }
    sleep 0.1
    assert_raises(RuntimeError) { wg.add(1) }
  end
end
