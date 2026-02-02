class Board
  attr_reader :height, :width

  EMPTY_SPACE = :empty
  def initialize(height = 3, width = 3)
    @height = height
    @width = width
    @empty_spaces = height * width
    @spaces = Array.new(height) { Array.new(width) { EMPTY_SPACE } }
  end

  def show
    @spaces.map { |row| row.map { |space| stringify(space) } }
  end

  def [](row, col)
    raise StandardError, 'Out of bounds space' unless legal_coords?(row, col)

    stringify(@spaces[row][col])
  end

  def []=(row, col, mark)
    raise StandardError, 'Board is full' if full?
    raise StandardError, 'Out of bounds space' unless legal_coords?(row, col)
    raise StandardError, "Can't occupy an occupied space" unless empty_space?(row, col)

    @empty_spaces -= 1
    @spaces[row][col] = mark.to_sym
  end

  def full?
    @empty_spaces.zero?
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

  private

  def stringify(value)
    value == EMPTY_SPACE ? ' ' : value.to_s
  end

  def empty_space?(row, col)
    @spaces[row][col] == EMPTY_SPACE
  end

  def legal_coords?(row, col)
    row.between?(0, height - 1) && col.between?(0, width - 1)
  end
end
