require_relative 'shared_board_tests'

class Board
  attr_reader :height, :width, :spaces

  EMPTY_SPACE = :empty
  def initialize(height = 3, width = 3)
    @height = height
    @width = width
    @empty_spaces = height * width
    @spaces = Array.new(height) { Array.new(width) { EMPTY_SPACE } }
  end

  def [](row, col)
    raise StandardError, 'Out of bounds space' unless legal_coords?(row, col)

    @spaces[row][col]
  end

  def []=(row, col, mark)
    raise StandardError, 'Board is full' if full?
    raise StandardError, 'Out of bounds space' unless legal_coords?(row, col)
    raise StandardError, "Can't occupy an occupied space" unless empty_space?(row, col)

    @empty_spaces -= 1
    @spaces[row][col] = mark
  end

  def full?
    @empty_spaces.zero?
  end

  def each_row(&block)
    spaces.each(&block)
  end

  def each_column
    return to_enum(:each_column) unless block_given?

    width.times { |column_index| yield @spaces.map { |row| row[column_index] } }
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

  def empty_space?(row, col)
    @spaces[row][col] == EMPTY_SPACE
  end

  def legal_coords?(row, col)
    row.between?(0, height - 1) && col.between?(0, width - 1)
  end

  def diagonal_iteration(pair, transformation)
    result = []
    while legal_coords?(*pair)
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
      empty_board = Array.new(3) { Array.new(3) { :empty } }
      expect(board.spaces).to eq(empty_board)
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
      it 'returns the correct diagonals for the top center space' do
        expected_result = [%w[1 5], %w[1 3]]
        expect(board.diagonals_at(0, 1)).to eq expected_result
      end
      it 'returns the correct diagonals for the center left space' do
        expected_result = [%w[3 7], %w[1 3]]
        expect(board.diagonals_at(1, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the center right space' do
        expected_result = [%w[1 5], %w[5 7]]
        expect(board.diagonals_at(1, 2)).to eq expected_result
      end
      it 'returns the correct diagonals for the lower center space' do
        expected_result = [%w[3 7], %w[5 7]]
        expect(board.diagonals_at(2, 1)).to eq expected_result
      end
    end
  end
  context 'when creating a square, even sided board' do
    let(:row) { 3 }
    let(:column) { 3 }
    subject(:board) { described_class.new(8, 8) }
    it 'can create an empty board' do
      empty_board = Array.new(8) { Array.new(8) { :empty } }
      expect(board.spaces).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
    context 'when running diagonals tests' do
      before { fill_board_with_numbers }
      it 'returns a list of length two' do
        expect(board.diagonals_at(row, column).length).to eq 2
      end
      it 'returns the correct diagonals for the [0, 0] coordinates' do
        expected_result = [%w[0 9 18 27 36 45 54 63], %w[0]]
        expect(board.diagonals_at(0, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 7] coordinates' do
        expected_result = [%w[7], %w[7 14 21 28 35 42 49 56]]
        expect(board.diagonals_at(0, 7)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 3] coordinates' do
        expected_result = [%w[3 12 21 30 39], %w[3 10 17 24]]
        expect(board.diagonals_at(0, 3)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 4] coordinates' do
        expected_result = [%w[4 13 22 31], %w[4 11 18 25 32]]
        expect(board.diagonals_at(0, 4)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 5] coordinates' do
        expected_result = [%w[5 14 23], %w[5 12 19 26 33 40]]
        expect(board.diagonals_at(0, 5)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 6] coordinates' do
        expected_result = [%w[6 15], %w[6 13 20 27 34 41 48]]
        expect(board.diagonals_at(0, 6)).to eq expected_result
      end
      it 'returns the correct diagonals for the [0, 7] coordinates' do
        expected_result = [%w[7], %w[7 14 21 28 35 42 49 56]]
        expect(board.diagonals_at(0, 7)).to eq expected_result
      end
      it 'returns the correct diagonals for the [1, 0] coordinates' do
        expected_result = [%w[8 17 26 35 44 53 62], %w[1 8]]
        expect(board.diagonals_at(1, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the [1, 7] coordinates' do
        expected_result = [%w[6 15], %w[15 22 29 36 43 50 57]]
        expect(board.diagonals_at(1, 7)).to eq expected_result
      end
      it 'returns the correct diagonals for the [3, 0] coordinates' do
        expected_result = [%w[24 33 42 51 60], %w[3 10 17 24]]
        expect(board.diagonals_at(3, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the [3, 7] coordinates' do
        expected_result = [%w[4 13 22 31], %w[31 38 45 52 59]]
        expect(board.diagonals_at(3, 7)).to eq expected_result
      end
      it 'returns the correct diagonals for the [7, 0] coordinates' do
        expected_result = [%w[56], %w[7 14 21 28 35 42 49 56]]
        expect(board.diagonals_at(7, 0)).to eq expected_result
      end
      it 'returns the correct diagonals for the [7, 4] coordinates' do
        expected_result = [%w[24 33 42 51 60], %w[39 46 53 60]]
        expect(board.diagonals_at(7, 4)).to eq expected_result
      end
      it 'returns the correct diagonals for the [7, 7] coordinates' do
        expected_result = [%w[0 9 18 27 36 45 54 63], %w[63]]
        expect(board.diagonals_at(7, 7)).to eq expected_result
      end
    end
  end

  context 'when creating a wider-than-taller board' do
    let(:row) { 3 }
    let(:column) { 5 }
    subject(:board) { described_class.new(6, 7) }
    it 'creates an empty board' do
      empty_board = Array.new(6) { Array.new(7) { :empty } }
      expect(board.spaces).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
    context 'when running diagonals tests' do
      before { fill_board_with_numbers }
      it 'returns the correct diagonals for the [3, 0] coordinates' do
        expected_result = [%w[21 29 37], %w[3 9 15 21]]
        expect(board.diagonals_at(3, 0)).to eq expected_result
      end
    end
  end
  context 'when creating a taller-than-wider board' do
    let(:row) { 5 }
    let(:column) { 3 }
    subject(:board) { described_class.new(7, 6) }
    it 'creates an empty board' do
      empty_board = Array.new(7) { Array.new(6) { :empty } }
      expect(board.spaces).to eq(empty_board)
    end
    context 'when running common board tests' do
      include_examples 'common_board_tests'
    end
    context 'when running diagonals tests' do
      before { fill_board_with_numbers }
      it 'returns the correct diagonals for the [1, 0] coordinates' do
        expected_result = [%w[6 13 20 27 34 41], %w[1 6]]
        expect(board.diagonals_at(1, 0)).to eq expected_result
      end
    end
  end
end
