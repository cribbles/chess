require 'byebug'
require_relative 'pieces'

class Board
  include ChessUtils
  include ChessUtils::Renderable

  def initialize
    @rows = Array.new(SIZE) { Array.new(SIZE) }
  end

  def [](pos)
    x, y = pos
    rows[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    rows[x][y] = piece
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]

    if piece.nil?
      raise ArgumentError.new "Nil starting piece"
    elsif !piece.moves.include?(end_pos)
      raise ArgumentError.new "Invalid move"
    end

    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos

    piece.first_move_taken if piece.is_a?(Pawn)
  end

  def on_board?(pos)
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
    dup = Board.new
    pieces.each { |piece| dup[piece.pos] = piece.dup }

    dup
  end

  def piece?(pos)
    self[pos].is_a?(Piece)
  end

  def checkmate?(color)
    pieces = self.pieces.select { |piece| piece.color == color }

    in_check?(color) && pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def fill_rows
    STARTING_POSITIONS.each do |coord, piece|
      drop_piece(piece, [0, coord],          :black)
      drop_piece(piece, [(SIZE - 1), coord], :white)
    end

    (0...SIZE).each do |coord|
      drop_piece(Pawn, [1, coord],          :black)
      drop_piece(Pawn, [(SIZE - 2), coord], :white)
    end
  end

  protected
  attr_reader :rows

  private

  def drop_piece(piece, pos, color)
    self[pos] = constantize(piece).new(self, pos, color)
  end

  def constantize(piece)
    Object.const_get(piece.to_s.capitalize)
  end
end
