require "optparse"
opt = OptionParser.new

# 入力を配列に格納
begin
  # ボウリングでは1投での得点をカウントという
  counts = opt
    .parse(ARGV)[0].split(",")
    .map { |count| count == "X" ? [10, nil] : count.to_i } # ストライクの場合2投目がないのでnilで埋める
    .flatten
    .select.with_index { |count, index| index < 18 || (index >= 18 && !count.nil?) }
rescue
  puts "正しいスコアを入力してください"
  return
end

# フレーム毎に配列に格納した二次元配列にする
counts_per_frame = [*0..9].map.with_index do |_, index|
  # 10フレーム目が3投ある場合
  if (index == 9 && counts.length > 20)
    [counts[18], counts[19], counts[20]]
  else
    [counts[2 * index], counts[2 * index + 1]]
  end
end

class Shot
  def initialize(count)
    @count = count
  end

  def count
    if @count == "X"
      10
    elsif @count.nil?
      nil
    else
      @count.to_i
    end
  end
end

class Frame
  # [shot1, shot2]
  def initialize(shots)
    @counts = shots.map { |shot| shot.count }
  end

  def type
    if (@counts[0] == 10)
      "strike"
    elsif (@counts[0] + @counts[1] == 10)
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

shots = counts_per_frame.map do |counts|
  counts.map { |count| Shot.new(count) }
end
frames = shots.map { |shot| Frame.new(shot) }
game = Game.new(frames)

puts game.score
