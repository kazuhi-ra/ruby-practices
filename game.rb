class Game
  # [frame1, frame2, .., frame10]
  def initialize(frames)
    @frames = frames
  end

  def score_ex_bonus
    @frames.reduce(0) do |result, frame|
      result + frame.score
    end
  end

  def next_frame(index)
    @frames[index + 1]
  end

  def after_next_frame(index)
    @frames[index + 2] unless index == 8 || index == 9
  end

  def last_frame(index)
    index == 9
  end

  def bonus
    @frames.each_with_index.reduce(0) do |result, (frame, index)|
      case frame.type
      when "normal"
        result
      when "spare"
        if last_frame(index)
          result
        else
          result + @frames[index + 1].first_shot
        end
      when "strike"
        if last_frame(index)
          result
        else
          if @frames[index + 1].second_shot.nil?
            result + next_frame(index).first_shot + after_next_frame(index).first_shot
          else
            result + next_frame(index).first_shot + next_frame(index).second_shot
          end
        end
      end
    end
  end

  def score
    score_ex_bonus + bonus
  end
end
