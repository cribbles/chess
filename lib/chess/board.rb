require_relative 'pieces'
require_relative '../chess_utils/chess_utils'

class Board
  include ChessUtils
  include ChessUtils::Renderable

  def initialize
    @rows = Array.new(SIZE) { Array.new(SIZE) }
  end

  def [](pos)
    row, col = pos
    rows[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    rows[row][col] = piece
  end

  def move_piece(piece, pos)
    self[pos] = piece
    self[piece.pos] = nil
    piece.pos = pos
  end

  def in_range?(pos)
    pos.all? { |coord| coord.between?(0, SIZE - 1) }
  end

  def in_check?(color)
    king = pieces.find do |piece|
      piece.is_a?(King) && piece.color == color
    end

    opposing_pieces = pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.moves.any? { |move| move == king.pos }
    end
  end

  def pieces
    rows.flatten.compact
  end

  def dup
    duped_board = self.class.new

    pieces.each do |piece|
      piece.class.new(duped_board, piece.color, piece.pos)
    end

    duped_board
  end

  def empty?(pos)
    self[pos].nil?
  end

  def piece?(pos)
    self[pos].is_a?(Piece)
  end

  def checkmate?(color)
    pieces = self.pieces.select { |piece| piece.color == color }

    in_check?(color) && pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def fill_rows
    positions.map do |coord, piece|
      piece.new(self, :black, [0, coord])
      piece.new(self, :white, [(SIZE - 1), coord])
    end

    (0...SIZE).each do |coord|
      Pawn.new(self, :black, [1, coord])
      Pawn.new(self, :white, [(SIZE - 2), coord])
    end
  end

  def add_piece(piece, pos)
    raise 'space not empty' unless empty?(pos)

    self[pos] = piece
  end

  protected
  attr_reader :rows

  private

  def positions
    STARTING_POSITIONS.inject({}) do |positions, (coord, piece)|
      positions.merge(coord => constantize(piece))
    end
  end

  def constantize(piece)
    Object.const_get(piece.to_s.capitalize)
  end
end
