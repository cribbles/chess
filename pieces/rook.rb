require_relative 'sliding_piece'

class Rook < SlidingPiece
  def deltas
    DELTAS[:cardinals]
  end
end
