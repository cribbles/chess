require_relative 'stepping_piece.rb'

class King < SteppingPiece
  def deltas
    DELTAS[:diagonals] + DELTAS[:cardinals]
  end
end
