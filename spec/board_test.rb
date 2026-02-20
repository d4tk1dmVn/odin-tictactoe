require_relative 'shared_board_tests'

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

  def diagonals_at(row, col)
    raise StandardError, 'Out of bounds space' unless legal_coords?(row, col)

    upper_left_arm = diagonal_iteration([row - 1, col - 1], ->(r, c) { [r - 1, c - 1] })
    lower_right_arm = diagonal_iteration([row + 1, col + 1], ->(r, c) { [r + 1, c + 1] })
    left_diagonal = upper_left_arm.reverse + [self[row, col]] + lower_right_arm
    upper_right_arm = diagonal_iteration([row - 1, col + 1], ->(r, c) { [r - 1, c + 1] })
    lower_left_arm = diagonal_iteration([row + 1, col - 1], ->(r, c) { [r + 1, c - 1] })
    right_diagonal = upper_right_arm.reverse + [self[row, col]] + lower_left_arm
    [left_diagonal, right_diagonal]
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

  def diagonal_iteration(pair, transformation)
    result = []
    until !legal_coords?(*pair) do
      result.append(self[*pair])
      pair = transformation.call(*pair)
    end
    result
  end
end

describe Board do
  let(:mark) { '$' }
  context 'when creating a square, odd sided board' do
    let(:row) { 2 }
    let(:column) { 2 }
    subject(:board) { described_class.new }
    it 'can create an empty board' do
      empty_board = Array.new(3) { Array.new(3) { ' ' } }
      expect(board.show).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
    context 'when running diagonals tests' do
      before { fill_board_with_numbers }
      it 'returns a list of length two' do
        expect(board.diagonals_at(0, 0).length).to eq 2
      end
      it 'returns the correct diagonals for the top left corner space' do
        expected_result = [%w[0 4 8], %w[0]]
        expect(board.diagonals_at(0, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the top right corner space' do
        expected_result = [%w[2], %w[2 4 6]]
        expect(board.diagonals_at(0, 2)).to eq expected_result
      end
      it 'returns the correct diagonals for the lower left corner space' do
        expected_result = [%w[6], %w[2 4 6]]
        expect(board.diagonals_at(2, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the lower right corner space' do
        expected_result = [%w[0 4 8], %w[8]]
        expect(board.diagonals_at(2, 2)).to eq expected_result
      end
      it 'returns the correct diagonals for the center space' do
        expected_result = [%w[0 4 8], %w[2 4 6]]
        expect(board.diagonals_at(1, 1)).to eq expected_result
      end
    end
  end
  context 'when creating a square, even sided board' do
    let(:row) { 3 }
    let(:column) { 3 }
    subject(:board) { described_class.new(8, 8) }
    it 'can create an empty board' do
      empty_board = Array.new(8) { Array.new(8) { ' ' } }
      expect(board.show).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
    context 'when running diagonals tests' do
      before { fill_board_with_numbers }
      it 'returns a list of length two' do
        expect(board.diagonals_at(row, column).length).to eq 2
      end
    end
  end

  context 'when creating a wider-than-taller board' do
    let(:row) { 3 }
    let(:column) { 5 }
    subject(:board) { described_class.new(6, 7) }
    it 'creates an empty board' do
      empty_board = Array.new(6) { Array.new(7) { ' ' } }
      expect(board.show).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
  end
  context 'when creating a taller-than-wider board' do
    let(:row) { 5 }
    let(:column) { 3 }
    subject(:board) { described_class.new(7, 6) }
    it 'creates an empty board' do
      empty_board = Array.new(7) { Array.new(6) { ' ' } }
      expect(board.show).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
  end
end
