require_relative '../lib/tictactoe_arbiter'

def allow_board_scenario(rows)
  cols = rows.transpose
  left_diag = rows.map.with_index { |row, index| row[index] }
  right_diag = rows.map.with_index { |row, index| row[row.length - 1 - index] }
  allow(board).to receive(:each_row).and_return(rows)
  allow(board).to receive(:each_column).and_return(cols)
  allow(board).to receive(:diagonals_at).with(1, 1).and_return([left_diag, right_diag])
end

def expect_winner(expected_winner)
  expect(arbiter.winner?).to be true
  expect(arbiter.winner).to eq expected_winner
end

describe TicTacToeArbiter do
  let(:board) { instance_double('board') }
  subject(:arbiter) { described_class.new(board) }
  context 'when checking for a winner on an empty board' do
    before do
      allow_board_scenario([['', '', ''], ['', '', ''], ['', '', '']])
      allow(board).to receive(:full?).and_return false
    end
    it 'there is no winner' do
      expect(arbiter.winner?).to be false
      expect(arbiter.winner).to be nil
    end
    it 'there is no tie' do
      expect(arbiter.tie?).to be false
    end
  end
  context 'when checking for a winner on full board with no winner' do
    before do
      allow_board_scenario([%w[O X O], %w[X O X], %w[X O X]])
      allow(board).to receive(:full?).and_return true
    end
    it 'there is no winner' do
      expect(arbiter.winner?).to be false
      expect(arbiter.winner).to be nil
    end
    it 'there is a tie' do
      expect(arbiter.tie?).to be true
    end
  end
  context 'when checking for a winner on a board with an X winner by rows' do
    before { allow_board_scenario([%w[O O X], %w[X X X], %w[O X O]]) }
    it 'there is a winner' do
      expected_winner = 'X'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a board with an O winner by rows' do
    before { allow_board_scenario([%w[O X X], %w[X X O], %w[O O O]]) }
    it 'there is a winner' do
      expected_winner = 'O'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an X winner by columns' do
    before { allow_board_scenario([%w[X O O], %w[X O X], %w[X X O]]) }
    it 'there is a winner' do
      expected_winner = 'X'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an O winner by columns' do
    before { allow_board_scenario([%w[X O O], %w[X O X], %w[O O X]]) }
    it 'there is a winner' do
      expected_winner = 'O'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an X winner by left diagonal' do
    before { allow_board_scenario([%w[X O O], %w[X X O], %w[O O X]]) }
    it 'there is a winner' do
      expected_winner = 'X'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an O winner by left diagonal' do
    before { allow_board_scenario([%w[O X X], %w[O O X], %w[X X O]]) }
    it 'there is a winner' do
      expected_winner = 'O'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an X winner by right diagonal' do
    before { allow_board_scenario([%w[O O X], %w[O X O], %w[X X O]]) }
    it 'there is a winner' do
      expected_winner = 'X'
      expect_winner(expected_winner)
    end
  end
  context 'when checking for a winner on a bord with an O winner by left diagonal' do
    before { allow_board_scenario([%w[X O O], %w[X O X], %w[O X O]]) }
    it 'there is a winner' do
      expected_winner = 'O'
      expect_winner(expected_winner)
    end
  end
end
