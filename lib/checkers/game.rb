require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_reader :current_player, :board, :red, :blue

  def initialize(board, players)
    @board = board
    @red = players.fetch(:red, ComputerPlayer.new(:red, board))
    @blue = players.fetch(:blue, ComputerPlayer.new(:blue, board))
    @current_player = blue
  end

  def play
    board.fill_rows

    until board.won?
      display_board
      play_turn
      switch_players!
    end

    end_game
  end

  private
  attr_reader :players, :red, :blue
  attr_writer :current_player

  def switch_players!
    self.current_player = (current_player == blue) ? red : blue
  end

  def computer_player?
    current_player.is_a?(ComputerPlayer)
  end

  def display_board
    system('clear')
    puts board.render

    if !board.won?
      puts "\n#{current_player}'s turn"
      sleep(1) if computer_player?
    end
  end

  def play_turn
    moves = []
    moves = current_player.get_moves until moves.any?

    perform_moves(moves)
  rescue InvalidMoveError => e
    puts e.message unless e.nil?
    puts "invalid move, try again"
    retry
  end

  def perform_moves(moves)
    start_pos = moves.shift
    piece = board[start_pos]

    if !piece
      raise InvalidMoveError, "couldn't find piece at starting position"
    elsif piece.color != current_player.color
      raise InvalidMoveError, "not your piece!"
    else
      piece.perform_moves(moves)
      piece.maybe_promote
    end
  end

  def end_game
    display_board
    puts "Game over!\n\nWinner: #{get_winner}\n\n"
  end

  def get_winner
    [red, blue].find { |player| player.color == board.winner }
  end
end
