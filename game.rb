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
    @frames.reduce(0) do |result, frame|
      case frame.type
      when "normal"
        result
      when "spare"
        if last_frame(frame.number)
          result
        else
          result + next_frame(frame.number).first_count
        end
      when "strike"
        if last_frame(frame.number)
          result
        else
          if next_frame(frame.number).second_count.nil?
            result + next_frame(frame.number).first_count + after_next_frame(frame.number).first_count
          else
            result + next_frame(frame.number).first_count + next_frame(frame.number).second_count
          end
        end
      end
    end
  end

  def score
    score_ex_bonus + bonus
  end
end
