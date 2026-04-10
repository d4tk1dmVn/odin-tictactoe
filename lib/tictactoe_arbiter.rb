require_relative 'arbiter'

class TicTacToeArbiter
  include Arbiter

  attr_reader :winner

  def initialize(board)
    @board = board
    @winner = nil
  end

  def winner?
    exes = triad_wins?(%w[X X X])
    os = triad_wins?(%w[O O O])
    @winner = exes ? 'X' : (os ? 'O' : nil)
    exes || os
  end

  def tie?
    winner.nil? && @board.full?
  end

  private

  def triad_wins?(triad)
    rows = @board.each_row
    cols = @board.each_column
    diagonals = @board.diagonals_at(1, 1)
    [rows, cols, diagonals].any? { |arr| arr.include?(triad) }
  end
end
