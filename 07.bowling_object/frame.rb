require_relative "./shot"

class Frame
  attr_reader :number
  # counts: [3, 6], ["X"], ...
  def initialize(counts, frame_number)
    @shots = counts.map { |count| Shot.new(count) }
    @number = frame_number
  end

  def strike?
    first_count == 10
  end

  def spare?
    !second_count.nil? && first_count + second_count == 10
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

  def score
    @shots
      .map { |shot| shot.count }
      .sum
  end
end
