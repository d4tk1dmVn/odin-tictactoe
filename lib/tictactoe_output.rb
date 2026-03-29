class TicTacToeOutput

  def show_board(spaces)
    rows_as_strings = spaces.map { |row| row_as_string(row) }
    output = ''
    rows_as_strings.each { |row| output += separator + row }
    print output + separator
  end

  private

  def row_as_string(row)
    sanitized = row.map { |space| space.chars[0] }
    a, b, c = *sanitized
    "\t| #{a} | #{b} | #{c} |\n"
  end

  def separator
    "\t.---.---.---.\n"
  end
end
