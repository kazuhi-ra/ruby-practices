require_relative "./shot"

class Frame
  attr_reader :number
  # counts: [3, 6], ["X"], ...
  def initialize(counts, frame_number)
    @shots = counts.map { Shot.new(_1) }
    @number = frame_number
  end

  def strike?
    first_count == 10
  end

  def spare?
    !strike? && first_count + second_count == 10
  end

  def number_of_shots
    @shots.size
  end

  def first_count
    @shots[0].count
  end

  def second_count
    @shots[1].count
  end

  def last?
    @number == 10
  end

  def score
    @shots
      .map { _1.count }
      .sum
  end
end
