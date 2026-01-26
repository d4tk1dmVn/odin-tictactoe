def expect_board_read_to_raise_out_of_bounds(row, column)
  expect { board[row, column] }.to raise_error('Out of bounds space')
end

def expect_board_write_to_raise_out_of_bounds(row, column)
  expect { board[row, column] = mark }.to raise_error('Out of bounds space')
end

def expect_mark_to_change(row, column)
  expect { board[row, column] = mark }.to change { board[row, column] }.from(' ').to(mark)
end

def fill_board_with_mark
  board.height.times { |row| board.width.times { |column| board[row, column] = mark } }
end

def fill_board_with_numbers
  content = 0
  board.height.times do |row|
    board.width.times do |column|
      board[row, column] = content.to_s
      content += 1
    end
  end
end

def create_expected_output_of_marks
  Array.new(board.height) { Array.new(board.width) { mark } }
end

def create_expected_output_of_numbers
  (0...(board.height * board.width)).map(&:to_s).each_slice(board.width).to_a
end

RSpec.shared_examples 'common_board_tests' do
  context 'when reading/writing specific and valid spaces' do
    it 'can read a particular space of the empty board' do
      expect(board[row, column]).to eq(' ')
    end
    it 'can occupy an particular space on the empty board' do
      expect_mark_to_change(row, column)
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

  context 'when attempting to write out of the board bounds' do
    it "can't write a negative row" do
      expect_board_write_to_raise_out_of_bounds(-4, column)
    end
    it "can't write a negative column" do
      expect_board_write_to_raise_out_of_bounds(row, -4)
    end
    it "can't write a row bigger than the board row size" do
      out_of_bounds_row = board.height + 1
      expect_board_write_to_raise_out_of_bounds(out_of_bounds_row, column)
    end
    it "can't write a column bigger than the board column size" do
      out_of_bounds_column = board.width + 1
      expect_board_write_to_raise_out_of_bounds(row, out_of_bounds_column)
    end
  end

  context 'when checking if the board is full' do
    it 'can return false when the board was just created' do
      expect(board.full?).to be false
    end
    it 'can return false when the board has one mark' do
      board[row, column] = mark
      expect(board.full?).to be false
    end
    it 'can return true when we fill the board' do
      fill_board_with_mark
      expect(board.full?).to be true
    end
  end

  context 'when the board is full' do
    before { fill_board_with_mark }
    it "can't occupy any space on the board" do
      expect { board[row, column] = mark }.to raise_error('Board is full')
    end
  end

  context 'when going over the rows of the board' do
    context 'when a block is given' do
      it 'yields the control height amount of times' do
        expect { |b| board.each_row(&b) }.to yield_control.exactly(board.height).times
      end
      it 'yields the content of each row in board filled with the same mark' do
        fill_board_with_mark
        expected_output = create_expected_output_of_marks
        expect { |b| board.each_row(&b) }.to yield_successive_args(*expected_output)
      end
      it 'yields the content of each row in board filled with numbers' do
        fill_board_with_numbers
        expected_output = create_expected_output_of_numbers
        expect { |b| board.each_row(&b) }.to yield_successive_args(*expected_output)
      end
    end

    context 'when no block is given'do
      it 'returns an enumerator' do
        expect(board.each_row).to be_an(Enumerator)
      end
      it 'returns the content of all rows in board filled with the same mark' do
        fill_board_with_mark
        expected_output = create_expected_output_of_marks
        expect(board.each_row.to_a).to eq(expected_output) 
      end
      it 'returns the content of all rows in board filled with numbers' do
        fill_board_with_numbers
        expected_output = create_expected_output_of_numbers
        expect(board.each_row.to_a).to eq(expected_output)
      end
    end
  end

  context 'when going over the columns of the board' do
    context 'when a block is given' do
      it 'yields the control width amount of times' do
        expect { |b| board.each_column(&b) }.to yield_control.exactly(board.width).times
      end
      it 'yields the content of each column in board filled with the same mark' do
        fill_board_with_mark
        expected_output = create_expected_output_of_marks.transpose
        expect { |b| board.each_column(&b) }.to yield_successive_args(*expected_output)
      end
      it 'yields the content of each column in board filled with numbers' do
        fill_board_with_numbers
        expected_output = create_expected_output_of_numbers.transpose
        expect { |b| board.each_column(&b) }.to yield_successive_args(*expected_output)
      end
    end

    context 'when no block is given'do
      it 'returns an enumerator' do
        expect(board.each_column).to be_an(Enumerator)
      end
      it 'returns the content of all columns in board filled with the same mark' do
        fill_board_with_mark
        expected_output = create_expected_output_of_marks.transpose
        expect(board.each_column.to_a).to eq(expected_output) 
      end
      it 'returns the content of all columns in board filled with numbers' do
        fill_board_with_numbers
        expected_output = create_expected_output_of_numbers.transpose
        expect(board.each_column.to_a).to eq(expected_output)
      end
    end
  end
end
