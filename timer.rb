class Timer
  def initialize
    reset
  end
  
  def frame(div, num)
    ((milliseconds - @ms_offset)>>div)%num
  end
  
  def time
    milliseconds - @ms_offset
  end
  
  def reset
    @ms_offset = milliseconds
  end
end
