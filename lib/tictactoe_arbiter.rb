require_relative 'arbiter'

class TicTacToeArbiter
  include Arbiter

  attr_accessor :winner

  def initialize(board)
    @board = board
  end

  def winner?
    rows = @board.each_row
    cols = @board.each_column
    diagonals = @board.diagonals_at(1, 1)
    exes = %w[X X X]
    os = %w[O O O]
    [rows, cols, diagonals].any? { |arr| arr.include?(exes) || arr.include?(os) }
  end

  def tie?
    !winner? && @board.full?
  end
end
