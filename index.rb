require "optparse"

require "./shot"
require "./frame"
require "./game"

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

# インスタンス生成
shots = counts_per_frame.map do |counts|
  counts.map { |count| Shot.new(count) }
end
frames = shots.map { |shot| Frame.new(shot) }
game = Game.new(frames)

# 実行
puts game.score
