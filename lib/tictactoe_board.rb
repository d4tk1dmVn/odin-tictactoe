require_relative 'board'

class TicTacToeBoard < Board
  def initialize
    super(3, 3)
  end

  def []=(row, col, mark)
    raise Exceptions::IllegalMoveError unless empty?(row, col)

    super
  end
end
