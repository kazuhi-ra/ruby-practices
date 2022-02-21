require_relative "./frame"

class Game
  NUMBER_OF_FRAME = 10
  # [frame1, frame2, .., frame10]
  def initialize(shots)
    begin
      counts = shots.split(",")

      counts_per_frame = [*1..NUMBER_OF_FRAME].map do |frame_number|
        if frame_number === 10
          counts.shift(counts.size) # 10投目は残った要素全てを渡す
        elsif counts[0].include?("X")
          counts.shift(1) << nil # ストライクの場合
        else
          counts.shift(2)
        end
      end

      @frames = counts_per_frame.map.with_index { |counts, frame_number| Frame.new(counts, frame_number) }
    rescue
      puts "正しいスコアを入力してください"
      return
    end
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

  def last_frame?(index)
    index == 9
  end

  def bonus
    @frames.reduce(0) do |result, frame|
      if (frame.strike?)
        if last_frame?(frame.number)
          result
        else
          if next_frame(frame.number).second_count.nil?
            result + next_frame(frame.number).first_count + after_next_frame(frame.number).first_count
          else
            result + next_frame(frame.number).first_count + next_frame(frame.number).second_count
          end
        end
      elsif (frame.spare?)
        if last_frame?(frame.number)
          result
        else
          result + next_frame(frame.number).first_count
        end
      else
        result
      end
    end
  end

  def score
    score_ex_bonus + bonus
  end
end
