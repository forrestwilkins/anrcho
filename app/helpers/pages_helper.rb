module PagesHelper
  def fib_seq size
    # returns fibonacci
    # sequence of desired length
    first = 0; second = 1
    sequence = []
    for i in 0..size
      sum = first + second
      first = second
      second = sum
      sequence << sum
    end
    return sequence
  end
end
