class TicTacToeInput
  def mark(remaining_spaces)
    return if remaining_spaces.empty?

    input = gets.chomp.to_i until remaining_spaces.keys.include?(input)
    remaining_spaces[input]
  end
end
