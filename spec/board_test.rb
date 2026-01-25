require_relative './shared_board_tests'

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
    @spaces.each do |row|
      yield row.map { |space| stringify(space) }
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
    row.between?(0, @height) && col.between?(0, @width)
  end
end

describe Board do
  let(:mark) { '$' }
  context 'when creating a square board' do
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
  end
  context 'when creating a rectangular board' do
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
end
