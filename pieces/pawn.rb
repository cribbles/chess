require_relative 'piece'

class Pawn < Piece
  def initialize(starting_pos, board, color)
    super(starting_pos, board, color)
    @first_move = true
    get_deltas
  end

  def first_move?
    @first_move
  end

  def first_move_taken
    @first_move = false
  end

  def moves
    moves = []
    base_deltas = (first_move? ? move_deltas : move_deltas.drop(1))

    base_deltas.each do |delta|
      move = get_move(pos, delta)
      possible_move = board.on_board?(move) && !board.piece?(move)

      (possible_move) ? moves << move : break
    end

    attack_deltas.each do |delta|
      move = get_move(pos, delta)
      possible_move = board.on_board?(move) && opponent?(move)

      moves << move if possible_move
    end

    moves
  end

  private
  attr_reader :move_deltas, :attack_deltas

  def get_deltas
    if self.color == :white
      @move_deltas = DELTAS[:white_pawns]
      @attack_deltas = DELTAS[:white_pawns_attack]
    else
      @move_deltas = DELTAS[:black_pawns]
      @attack_deltas = DELTAS[:black_pawns_attack]
    end
  end

  def get_move(pos, deltas)
    x, y = pos
    delta_x, delta_y = deltas

    [x + delta_x, y + delta_y]
  end
end
