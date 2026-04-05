require_relative 'boardgameloop'
require_relative 'tictactoe_arbiter'
require_relative 'tictactoe_board'
require_relative 'tictactoe_input'
require_relative 'tictactoe_output'
require_relative 'player'

class TicTacToeGameLoop
  include BoardGameLoop

  attr_reader :arbiter, :board, :input, :output, :players

  def initialize
    @board = TicTacToeBoard.new
    @arbiter = TicTacToeArbiter.new(@board)
    @input = TicTacToeInput.new
    @output = TicTacToeOutput.new
    @players = []
  end

  def reset
    @board = TicTacToeBoard.new
    @arbiter = TicTacToeArbiter.new(@board)
  end

  def turn
    output.show_board(board.spaces)
  end
end
