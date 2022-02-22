require_relative "./frame"

class Game
  NUMBER_OF_FRAMES = 10
  # [frame1, frame2, .., frame10]
  def initialize(shots)
    begin
      counts = shots.split(",")

      counts_per_frame = [*1..NUMBER_OF_FRAMES].map do |frame_number|
        if frame_number === 10
          counts.shift(counts.size) # 10投目は残った要素全てを渡す
        elsif counts[0].include?("X")
          counts.shift(1) # ストライクの場合
        else
          counts.shift(2)
        end
      end

      @frames = counts_per_frame.map.with_index(1) { |counts, frame_number| Frame.new(counts, frame_number) }
    rescue
      puts "正しいスコアを入力してください"
      return
    end
  end

  def score_ex_bonus
    @frames
      .map { |frame| frame.score }
      .sum
  end

  def next_frame(index)
    @frames[index]
  end

  def after_next_frame(index)
    @frames[index + 1] unless index == 9 || index == 10
  end

  def bonus
    @frames.sum do |frame|
      if frame.last?
        0
      else
        if (frame.strike?)
          if next_frame(frame.number).number_of_shots == 1 # 次のフレームが1投の場合
            next_frame(frame.number).first_count + after_next_frame(frame.number).first_count
          else
            next_frame(frame.number).first_count + next_frame(frame.number).second_count
          end
        elsif (frame.spare?)
          next_frame(frame.number).first_count
        else
          0
        end
      end
    end
  end

  def score
    score_ex_bonus + bonus
  end
end
