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
  puts "正しいく入力してください"
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

# 点数の種類を付け加える
enrich_counts_per_frame = counts_per_frame.map do |counts|
  type = if (counts[0] == 10)
      "strike"
    elsif (counts[0] + counts[1] == 10)
      "spare"
    else
      "normal"
    end

  { counts: counts, type: type }
end

score = 0
enrich_counts_per_frame.each_with_index do |counts_data, index|
  counts = counts_data[:counts]
  last_frame = index == 9
  second_from_the_last_frame = index == 8

  next_counts = enrich_counts_per_frame[index + 1][:counts] unless last_frame
  after_next_counts = enrich_counts_per_frame[index + 2][:counts] unless second_from_the_last_frame || last_frame

  case counts_data[:type]
  when "normal"
    score += counts.reduce { |result, count| result + count }
  when "spare"
    if last_frame
      score += counts.reduce { |result, count| result + count }
    else
      score += counts.reduce { |result, count| result + count } + next_counts[0]
    end
  when "strike"
    if last_frame
      score += counts.reduce { |result, count| result + count }
    else
      if next_counts[1].nil?
        score += 10 + next_counts[0] + after_next_counts[0]
      else
        score += 10 + next_counts[0] + next_counts[1]
      end
    end
  end
end

puts score
