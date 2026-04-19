require_relative '../lib/tictactoe_output'
require_relative '../lib/player'

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
  context 'when outputting players scores' do
    let(:players) { [Player.new('Pablo'), Player.new('Bablo')] }
    context 'when players have the same score' do
      it 'outputs that players are tied' do
        expected_output = 'Players are TIED'
        expect(output).to receive(:puts).with(expected_output)
        expect(output.show_scores(players))
      end
    end
    context 'when players have different scores' do
      it 'outputs each player score' do
        players[0].score += 1
        player_one_name = players[0].name
        player_one_score = players[0].score
        player_two_name = players[1].name
        player_two_score = players[1].score
        expected_output = "#{player_one_name}: #{player_one_score} | #{player_two_name}: #{player_two_score}"
        expect(output).to receive(:puts).with(expected_output)
        expect(output.show_scores(players))
      end
    end
  end
end
