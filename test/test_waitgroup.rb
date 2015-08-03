require 'test/unit'
require 'thread'
require 'channel/waitgroup'

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
      wg.add(5)
      ok1 = false
      ok2 = false
      ok3 = false
      ok4 = false
      ok5 = false
      go -> { sleep 0.1; ok1 = true; wg.done }
      go -> { sleep 0.2; ok2 = true; wg.done }
      go -> { sleep 0.3; ok3 = true; wg.done }
      go -> { sleep 0.4; ok4 = true; wg.done }
      go -> { sleep 0.5; ok5 = true; wg.done }
      wg.wait
      duration = Time.now - start
      assert_equal(true, duration > 0.45)
      assert_equal(true, duration < 0.70)
      assert_true(ok1)
      assert_true(ok2)
      assert_true(ok3)
      assert_true(ok4)
      assert_true(ok5)
      assert_raises(RuntimeError) { wg.done }
    end
  end
end
