require_relative '../lib/tictactoe_input'

def expect_reprompt(input_array, expected_result, board_state)
  expect(ttt_input).to receive(:gets).exactly(2).times.and_return(*input_array)
  expect(ttt_input.mark(board_state)).to eq(expected_result)
end

describe TicTacToeInput do
  subject(:ttt_input) { described_class.new }
  context 'when testing #mark' do
    let(:all_numbers) { %W[1\n 2\n 3\n 4\n 5\n 6\n 7\n 8\n 9\n] }
    let(:all_coords) { [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]] }
    let(:zipped) { all_numbers.map { |string| string.chomp.to_i }.zip(all_coords) }
    let(:board_state) { zipped.to_h }
    let(:diminished_board) { zipped[1..].to_h }
    context 'when getting valid input for marking the board' do
      it 'can return all coordinates correctly ' do
        expect(ttt_input).to receive(:gets).exactly(9).times.and_return(*all_numbers)
        expect(9.times.map { ttt_input.mark(board_state) }).to match_array(all_coords)
      end
    end
    context 'when getting invalid input for marking the board' do
      it 'remprompts when input is a random string' do
        expect_reprompt(%W[verybadinput\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is a positive numerical string outside of the 1-9 range' do
        expect_reprompt(%W[42\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is zero' do
        expect_reprompt(%W[0\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is a negative numerical string outside of the 1-9 range' do
        expect_reprompt(%W[-1\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when the number is a previously chosen number' do
        expect_reprompt(%W[1\n 2\n], [0, 1], diminished_board)
      end
      it 'returns nil when all valid numbers have been chosen' do
        expect(ttt_input.mark({})).to eq(nil)
      end
    end
  end
end
