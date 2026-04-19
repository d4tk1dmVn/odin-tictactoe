class TicTacToeOutput

  def show_board(spaces)
    rows_as_strings = spaces.map { |row| row_as_string(row) }
    output = ''
    rows_as_strings.each { |row| output += separator + row }
    print output + separator
  end

  def show_scores(players)
    if score_tie?(players)
      puts 'Players are TIED'
    else
      scores = players.map { |player| "#{player.name}: #{player.score}" }
      puts "#{scores[0]} | #{scores[1]}"
    end
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

  def score_tie?(players)
    players.map(&:score).uniq.size == 1
  end
end
