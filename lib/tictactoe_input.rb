class TicTacToeInput
  def initialize
    @remaining_spaces = {
      1 => [0, 0],
      2 => [0, 1],
      3 => [0, 2],
      4 => [1, 0],
      5 => [1, 1],
      6 => [1, 2],
      7 => [2, 0],
      8 => [2, 1],
      9 => [2, 2]
    }
  end

  def mark
    # numbered_space = gets.chomp.to_i
    # @remaining_spaces[numbered_space]
    numbered_space = gets.chomp.to_i
    @remaining_spaces[numbered_space]
  end
end
