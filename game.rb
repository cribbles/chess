require_relative 'board'
require_relative 'human_player'
require_relative 'chess_utils/chess_utils'

class Game
  attr_reader :board, :white, :black, :current_player

  def initialize(white_player = HumanPlayer.new(:white),
                 black_player = HumanPlayer.new(:black))
    @board = Board.new
    @white = white_player
    @black = black_player
    @current_player = white
  end

  def setup
    board.fill_rows
  end

  def play
    until won?
      render_game
      play_turn
      switch_players!
    end

    render_game
    puts "Checkmate!"
  end

  def play_turn
    puts "#{current_player}'s turn"
    move = nil
    move = current_player.get_move until valid_move?(move)
    start_pos, end_pos = move
    board.move(start_pos, end_pos)
  end

  def valid_move?(move)
    return false until move

    start_pos = move.first
    board.piece?(start_pos) && board[start_pos].color == current_player.color
  end

  def switch_players!
    @current_player = (current_player == white) ? black : white
  end

  def won?
    [:black, :white].any? { |color| board.checkmate?(color) }
  end

  private

  def render_game
    system("clear")
    puts board.render
  end
end
