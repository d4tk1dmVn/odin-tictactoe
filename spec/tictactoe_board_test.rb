require_relative "../lib/tictactoe_board"

describe TicTacToeBoard do
  subject(:board) { described_class.new }
  it 'is a board with exactly 3 rows' do
    expect(board.height).to eq(3)
  end
  it 'is a board with exactly 3 columns' do
    expect(board.width).to eq(3)
  end
end
