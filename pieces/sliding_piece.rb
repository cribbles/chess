require_relative 'piece'

class SlidingPiece < Piece
  def num_steps
    SIZE - 1
  end
end
