require_relative 'sliding_piece'

class Bishop < SlidingPiece
  def deltas
    DELTAS[:diagonals]
  end
end
