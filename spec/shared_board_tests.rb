def expect_board_read_to_raise_out_of_bounds(row, column)
  expect { board[row, column] }.to raise_error('Out of bounds space')
end

def expect_mark_to_change(row, column, mark)
  expect { board[row, column] = mark }.to change { board[row, column] }.from(' ').to(mark)
end

RSpec.shared_examples 'common_board_tests' do
  context 'when reading/writing specific and valid spaces' do
    it 'can read a particular space of the empty board' do
      expect(board[row, column]).to eq(' ')
    end
    it 'can occupy an particular space on the empty board' do
      expect_mark_to_change(row, column, mark)
    end
    it 'can read a particular space on the board after it was occupied' do
      board[row, column] = mark
      expect(board[row, column]).to eq(mark)
    end
    it "can't occupy an already occupied space on the board" do
      board[row, column] = mark
      expect { board[row, column] = '#' }.to raise_error("Can't occupy an occupied space")
    end
  end

  context 'when attempting to read out of the board bounds' do
    it "can't read a negative row" do
      expect_board_read_to_raise_out_of_bounds(-4, column)
    end
    it "can't read a negative column" do
      expect_board_read_to_raise_out_of_bounds(row, -4)
    end
    it "can't read a row bigger than the board row size" do
      out_of_bounds_row = board.height + 1
      expect_board_read_to_raise_out_of_bounds(out_of_bounds_row, column)
    end
    it "can't read a column bigger than the board column size" do
      out_of_bounds_column = board.width + 1
      expect_board_read_to_raise_out_of_bounds(row, out_of_bounds_column)
    end
  end
end
