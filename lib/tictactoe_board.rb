require_relative 'board'

class TicTacToeBoard < Board
  def initialize
    super(3, 3)
  end
end
