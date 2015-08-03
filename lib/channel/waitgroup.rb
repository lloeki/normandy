class WaitGroup
  def initialize
    @mutex = Mutex.new
    @count = 0
    @waiting = []
  end

  def add(count)
    sync! { @count += count }
  end

  def done
    sync! do
      fail 'negative count' if done?
      @count -= 1
      wake!
    end
  end

  private def done?
    @count == 0
  end

  def wait
    sync! do
      @waiting << Thread.current
      @mutex.sleep until done?
    end
  end

  private def wake!
    @waiting.each { |t| t.wakeup if t.alive? }
  end

  private def sync!(&block)
    @mutex.synchronize(&block)
  end
end
