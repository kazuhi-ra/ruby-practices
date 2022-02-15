class Frame
  # [shot1, shot2]
  def initialize(shots)
    @counts = shots.map { |shot| shot.count }
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
    if second_shot.nil?
      first_shot
    else
      @counts.reduce(0) { |result, count| result + count }
    end
  end
end
