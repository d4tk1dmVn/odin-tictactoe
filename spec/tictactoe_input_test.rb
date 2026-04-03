require_relative '../lib/tictactoe_input'

def expect_reprompt_mark(input_array, expected_result, board_state)
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
        expect_reprompt_mark(%W[verybadinput\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is a positive numerical string outside of the 1-9 range' do
        expect_reprompt_mark(%W[42\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is zero' do
        expect_reprompt_mark(%W[0\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when input is a negative numerical string outside of the 1-9 range' do
        expect_reprompt_mark(%W[-1\n 1\n], [0, 0], board_state)
      end
      it 'remprompts when the number is a previously chosen number' do
        expect_reprompt_mark(%W[1\n 2\n], [0, 1], diminished_board)
      end
      it 'returns nil when all valid numbers have been chosen' do
        expect(ttt_input.mark({})).to eq(nil)
      end
    end
  end
  context 'when testing #player_name' do
    let(:all_letters) { %w[AAA BBB CCC DDD EEE FFF GGG HHH III JJJ KKK LLL MMM NNN OOO PPP QQQ RRR SSS TTT UUU VVV WWW YYY XXX ZZZ] }
    let(:reprompt_cases) { %w[toolong TOOLONG aaaa sh aa1 aa$ AAA] }
    it 'can return alphabetic 3 charactered string for each anglosaxon character' do
      expect(ttt_input).to receive(:gets).exactly(26).times.and_return(*all_letters)
      expect(26.times.map { ttt_input.player_name }).to match_array(all_letters)
    end
    it 'reprompts when the player name is not an alphabetic 3 charactered string' do
      expect(ttt_input).to receive(:gets).exactly(7).times.and_return(*reprompt_cases)
      expect(ttt_input.player_name).to eq('AAA')
    end
  end
  context 'when testing #yes_no_question?' do
    let(:some_question) { "Is your refrigerator runninng?\n" }
    let(:generic_prompt) { "Y/N?:\n" }
    let(:bad_chars) { %w[a b c d e f g h i j k l m o p q r s t u v w x z y] }
    let(:weird_chars) { ['', ' ', '$', '#', '0', '?', '!', '1', '\0', 'é', 'ñ', 'y'] }
    let(:escape_chars) { ["\n", "\t", "\r", "\b", "\f", "\v", "\a", "\e", "\s", "\0", "\\", "\"", 'y'] }
    let(:edge_cases) { ['.', '.*', '^', '$', '|', '?', '+', '*', '(', ')', '[', ']', '{', '}', 'nil', nil, 'false', 'yn', 'YN', 'Yn', 'nY', 'YY', 'NN', 'yy', 'nn', 'y'] }
    it 'prints a generic prompt for input when no custom question is given' do
      allow(ttt_input).to receive(:gets).and_return('y')
      expect { ttt_input.yes_no_question? }.to output(generic_prompt).to_stdout
    end
    it 'prints a custom prompt for input when a custom question is given' do
      allow(ttt_input).to receive(:gets).and_return('y')
      expect { ttt_input.yes_no_question?(some_question) }.to output(some_question).to_stdout
    end
    it 'returns false if input given input is n or N' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(2).times.and_return('n', 'N')
      expect(2.times.map { ttt_input.yes_no_question? }).to match_array([false, false])
    end
    it 'returns true if input given input is n or N' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(2).times.and_return('y', 'Y')
      expect(2.times.map { ttt_input.yes_no_question? }).to match_array([true, true])
    end
    it 'reprompts for input if given wrong alphabetic chars' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(25).times.and_return(*bad_chars)
      expect(ttt_input.yes_no_question?).to be true
    end
    it 'reprompts for input if given weird chars' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(12).times.and_return(*weird_chars)
      expect(ttt_input.yes_no_question?).to be true
    end
    it 'reprompts for input if given escape chars' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(12).times.and_return(*escape_chars)
      expect(ttt_input.yes_no_question?).to be true
    end
    it 'reprompts for input if given edge cases chars' do
      allow(ttt_input).to receive(:puts)
      expect(ttt_input).to receive(:gets).exactly(26).times.and_return(*edge_cases)
      expect(ttt_input.yes_no_question?).to be true
    end
  end
end
