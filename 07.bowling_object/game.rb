require_relative "./frame"

class Game
  # [frame1, frame2, .., frame10]
  def initialize(shots)
    begin
      counts = shots
        .split(",")
        .map { |count| count == "X" ? [10, nil] : count.to_i } # ストライクの場合2投目がないのでnilで埋める
        .flatten
        .select.with_index { |count, index| index < 18 || (index >= 18 && !count.nil?) }

      counts_per_frame = [*0..9].map.with_index do |_, index|
        # 10フレーム目が3投ある場合
        if (index == 9 && counts.length > 20)
          [counts[18], counts[19], counts[20]]
        else
          [counts[2 * index], counts[2 * index + 1]]
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

  def last_frame(index)
    index == 9
  end

  def bonus
    @frames.reduce(0) do |result, frame|
      if (frame.strike?)
        if last_frame(frame.number)
          result
        else
          if next_frame(frame.number).second_count.nil?
            result + next_frame(frame.number).first_count + after_next_frame(frame.number).first_count
          else
            result + next_frame(frame.number).first_count + next_frame(frame.number).second_count
          end
        end
      elsif (frame.spare?)
        if last_frame(frame.number)
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
