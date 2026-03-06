require_relative "../lib/tictactoe_board"
require_relative "../lib/exceptions"

describe TicTacToeBoard do
  subject(:board) { described_class.new }
  it 'is a board with exactly 3 rows' do
    expect(board.height).to eq(3)
  end
  it 'is a board with exactly 3 columns' do
    expect(board.width).to eq(3)
  end
  it 'can not overwrite an occupied space' do
    board[0, 0] = 'X'
    expect { board[0, 0] = 'O' }.to raise_error(Exceptions::IllegalMoveError)
  end
end
