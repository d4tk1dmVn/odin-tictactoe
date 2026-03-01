require_relative '../lib/exceptions'
class Board
  attr_reader :height, :width, :spaces

  EMPTY_SPACE = :empty
  def initialize(height = 3, width = 3)
    @height = height
    @width = width
    @spaces = Array.new(height) { Array.new(width) { EMPTY_SPACE } }
  end

  def [](row, col)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    @spaces[row][col]
  end

  def []=(row, col, mark)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    @spaces[row][col] = mark
  end

  def full?
    height.times { |row| width.times { |col| return false if empty_space?(row, col) } }
    true
  end

  def each_row(&block)
    spaces.each(&block)
  end

  def each_column
    return to_enum(:each_column) unless block_given?

    width.times { |column_index| yield @spaces.map { |row| row[column_index] } }
  end

  def diagonals_at(row, col)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    diagonal_one = []
    diagonal_two = []
    height.times do |row_index|
      d1 = row_index - (row - col)
      d2 = (row + col) - row_index
      diagonal_one << self[row_index, d1] if legal_coords?(row_index, d1)
      diagonal_two << self[row_index, d2] if legal_coords?(row_index, d2)
    end
    [diagonal_one, diagonal_two]
  end

  private

  def empty_space?(row, col)
    @spaces[row][col] == EMPTY_SPACE
  end

  def legal_coords?(row, col)
    row.between?(0, height - 1) && col.between?(0, width - 1)
  end
end
