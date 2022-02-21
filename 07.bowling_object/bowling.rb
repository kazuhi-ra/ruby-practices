require_relative "./game"

# "6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5"
shots = ARGV[0]

game = Game.new(shots)

# 実行
puts game.score
