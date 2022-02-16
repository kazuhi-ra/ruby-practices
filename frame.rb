class Frame
  attr_accessor :number
  # [shot1, shot2]
  def initialize(shots, number)
    @counts = shots.map { |shot| shot.count }
    @number = number
  end

  def type
    if (first_shot == 10)
      "strike"
    elsif (first_shot + second_shot == 10)
      "spare"
    else
      "normal"
    end
  end

  def first_shot
    @counts[0]
  end

  def second_shot
    @counts[1]
  end

  def score
    @counts.reduce(0) do |result, count|
      if count.nil?
        result + 0
      else
        result + count
      end
    end
  end
end
