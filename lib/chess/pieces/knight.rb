require_relative 'stepping_piece'

class Knight < SteppingPiece
  def deltas
    DELTAS[:knights]
  end
end
