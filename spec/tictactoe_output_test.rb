require_relative '../lib/tictactoe_output'

describe TicTacToeOutput do
  subject(:output) { described_class.new }
  context 'when outputting the board' do
    context 'when the board is empty' do
      let(:empty_spaces) { Array.new(3) { Array.new(3) { ' ' } } }
      it 'can print an empty Tic-Tac-Toe board' do
        expected_output = "\t.---.---.---.\n\t|   |   |   |\n\t.---.---.---.\n\t|   |   |   |\n\t.---.---.---.\n\t|   |   |   |\n\t.---.---.---.\n"
        expect(output).to receive(:print).with(expected_output)
        expect(output.show_board(empty_spaces))
      end
    end
    context 'when the even spaces on the board are occupied' do
      let(:even_spaces) { [[' ', 'X', ' '], ['O', ' ', 'X'], ['  ', 'X', ' ']] }
      it 'can print the board with the even spaces occupied' do
        expected_output = "\t.---.---.---.\n\t|   | X |   |\n\t.---.---.---.\n\t| O |   | X |\n\t.---.---.---.\n\t|   | X |   |\n\t.---.---.---.\n"
        expect(output).to receive(:print).with(expected_output)
        expect(output.show_board(even_spaces))
      end
    end
    context 'when the odd spaces on the board are occupied' do
      let(:odd_spaces) { [['X', ' ', 'X'], [' ', 'O', ' '], ['X ', ' ', 'O']] }
      it 'can print the board with the odd spaces occupied' do
        expected_output = "\t.---.---.---.\n\t| X |   | X |\n\t.---.---.---.\n\t|   | O |   |\n\t.---.---.---.\n\t| X |   | O |\n\t.---.---.---.\n"
        expect(output).to receive(:print).with(expected_output)
        expect(output.show_board(odd_spaces))
      end
    end
    context 'when the board is fully occupied' do
      let(:full_spaces) { [['X', 'X', 'X'], ['O', 'O', 'X'], ['X ', 'X', 'O']] }
      it 'can print the board when it is fully occupied' do
        expected_output = "\t.---.---.---.\n\t| X | X | X |\n\t.---.---.---.\n\t| O | O | X |\n\t.---.---.---.\n\t| X | X | O |\n\t.---.---.---.\n"
        expect(output).to receive(:print).with(expected_output)
        expect(output.show_board(full_spaces))
      end
    end
  end
end
