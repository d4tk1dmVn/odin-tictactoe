class TicTacToeInput
  VALID_NAME_REGEX = /\A\p{Upper}{3}\z/.freeze
  MARK_MESSAGE = 'Input the square you want to mark'.freeze
  PLAYER_MESSAGE = 'Input your name'.freeze

  def mark(remaining_spaces)
    return if remaining_spaces.empty?

    input = ''
    input = read_integer until remaining_spaces.keys.include?(input)
    remaining_spaces[input]
  end

  def player_name
    input = ''
    input = read_name until input.match?(VALID_NAME_REGEX)
    input
  end

  private

  def read_integer
    gets(MARK_MESSAGE).chomp.to_i
  end

  def read_name
    gets(PLAYER_MESSAGE).chomp
  end
end
