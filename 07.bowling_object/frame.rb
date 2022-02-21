require_relative "./shot"

class Frame
  attr_reader :number
  # counts: [3, 6], [10, null], ...
  def initialize(counts, frame_number)
    @shots = counts.map { |count| Shot.new(count) }
    @number = frame_number
  end

  def type
    if (first_count == 10)
      "strike"
    elsif (first_count + second_count == 10)
      "spare"
    else
      "normal"
    end
  end

  def first_count
    @shots[0].count
  end

  def second_count
    @shots[1].count
  end

  def score
    @shots.reduce(0) do |result, shot|
      if shot.count.nil?
        result + 0
      else
        result + shot.count
      end
    end
  end
end
