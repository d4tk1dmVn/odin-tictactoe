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
  end

  def create_players
    raise Exceptions::PlayersAlreadyCreatedError if players.length.positive?

    2.times do |time|
      mark = (time % 2) == 0 ? 'X' : 'O'
      players << Player.new(input.player_name, mark)
    end
  end

  def reset
    @board = TicTacToeBoard.new
    @arbiter = TicTacToeArbiter.new(@board)
  end

  def turn(counter)
    output.show_board(board.spaces)
    row, col = *input.mark(translated_board)
    board[row, col] = players[counter % 2].mark
  end

  def game
    counter = 0
    until arbiter.winner?
      turn(counter)
      counter += 1
    end
  end

  private

  def translated_board
    result = KEYS_TO_COORDS_MAP.dup
    board_spaces = board.spaces.flatten
    board_spaces.each_with_index do |space, index|
      result.delete(index + 1) if space != ''
    end
    result
  end
end
