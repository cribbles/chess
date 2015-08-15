require_relative 'stepping_piece.rb'

class Knight < SteppingPiece
  def deltas
    DELTAS[:knights]
  end
end
