require_relative 'sliding_piece'

class Queen < SlidingPiece
  def deltas
    DELTAS[:diagonals] + DELTAS[:cardinals]
  end
end
