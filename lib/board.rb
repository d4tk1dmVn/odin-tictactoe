require_relative '../lib/exceptions'
class Board
  attr_reader :height, :width

  EMPTY_SPACE = :empty
  def initialize(height = 3, width = 3)
    @height = height
    @width = width
    @spaces = Array.new(height) { Array.new(width) { EMPTY_SPACE } }
  end

  def spaces
    @spaces.map { |row| row.map { |space| stringify(space) } }
  end

  def [](row, col)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    stringify(@spaces[row][col])
  end

  def []=(row, col, mark)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    @spaces[row][col] = mark.to_sym
  end

  def full?
    @spaces.all? { |row| !row.include?(EMPTY_SPACE) }
  end

  def empty?(row, col)
    raise Exceptions::OutOfBoundsError unless legal_coords?(row, col)

    @spaces[row][col] == EMPTY_SPACE
  end

  def each_row
    return to_enum(:each_row) unless block_given?

    @spaces.each do |row|
      yield row.map { |space| stringify(space) }
    end
  end

  def each_column
    return to_enum(:each_column) unless block_given?

    width.times do |column_index|
      column = @spaces.map { |row| row[column_index] }
      yield column.map { |space| stringify(space) }
    end
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

  def legal_coords?(row, col)
    row.between?(0, height - 1) && col.between?(0, width - 1)
  end

  def stringify(mark)
    mark == EMPTY_SPACE ? '' : mark.to_s
  end
end
