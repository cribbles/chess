require_relative '../chess_utils/chess_utils'

class Piece
  include ChessUtils

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(board, starting_pos, color)
    @board = board
    @pos = starting_pos
    @color = color
  end

  def moves
    x, y = pos
    moves = []

    deltas.each do |delta|
      num_steps.times do |step|
        delta_x, delta_y = delta
        x_move = delta_x * (step + 1)
        y_move = delta_y * (step + 1)
        move = [x + x_move, y + y_move]

        break if !possible_move?(move) || same_color_piece?(move)

        moves << move
        break if board.piece?(move)
      end
    end

    moves
  end

  def possible_move?(pos)
    board.on_board?(pos)
  end

  def same_color_piece?(pos)
    board.piece?(pos) && self.color == board[pos].color
  end

  def opponent?(pos)
    board.piece?(pos) && self.color != board[pos].color
  end

  def to_s
    piece = (color == :white ? WHITE_PIECES[to_sym] : BLACK_PIECES[to_sym])

    piece.colorize(:red)
  end

  def valid_moves
    self.moves.reject do |end_move|
      test_board = board.dup
      test_board.move(pos, end_move)

      test_board.in_check?(color)
    end
  end

  private

  def to_sym
    self.class.to_s.downcase.to_sym
  end
end
