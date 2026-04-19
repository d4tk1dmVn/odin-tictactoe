require_relative 'boardgameloop'
require_relative 'tictactoe_arbiter'
require_relative 'tictactoe_board'
require_relative 'tictactoe_input'
require_relative 'tictactoe_output'
require_relative 'player'
require_relative 'exceptions'

class TicTacToeGameLoop
  include BoardGameLoop

  KEYS_TO_COORDS_MAP = {
    1 => [0, 0],
    2 => [0, 1],
    3 => [0, 2],
    4 => [1, 0],
    5 => [1, 1],
    6 => [1, 2],
    7 => [2, 0],
    8 => [2, 1],
    9 => [2, 2]
  }.freeze

  attr_reader :arbiter, :board, :input, :output, :players

  def initialize
    @board = TicTacToeBoard.new
    @arbiter = TicTacToeArbiter.new(@board)
    @input = TicTacToeInput.new
    @output = TicTacToeOutput.new
    @players = []
    create_players
  end

  def reset
    @board = TicTacToeBoard.new
    @arbiter = TicTacToeArbiter.new(@board)
  end

  def turn(turn_counter)
    output.show_board(board.spaces)
    row, col = *input.mark(translated_board)
    board[row, col] = current_player(turn_counter).mark
  end

  def run_one_game
    turn_counter = 0
    until arbiter.winner? || board.full?
      turn(turn_counter)
      turn_counter += 1
    end
  end

  def main
    run_one_game
    unless arbiter.tie?
      winners_mark = arbiter.winner
      winner = players[0].mark == winners_mark ? players[0] : players[1]
      winner.score += 1
    end
    output.show_scores(players)
  end

  private

  def create_players
    raise Exceptions::PlayersAlreadyCreatedError if players.length.positive?

    2.times do |time|
      mark = time.even? ? 'X' : 'O'
      players << Player.new(input.player_name, mark)
    end
  end

  def current_player(turn_counter)
    raise Exceptions::PlayersNotCorrectlyCreatedError if players.length != 2

    players[turn_counter % 2]
  end

  def translated_board
    result = KEYS_TO_COORDS_MAP.dup
    board_spaces = board.spaces.flatten
    board_spaces.each_with_index do |space, index|
      result.delete(index + 1) if space != ''
    end
    result
  end
end
