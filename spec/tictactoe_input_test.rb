require_relative '../lib/tictactoe_input'

describe TicTacToeInput do
  subject(:ttt_input) { described_class.new }
  context 'when getting valid input for marking the board' do
    it 'can return [0, 0] when given 1' do
      allow(ttt_input).to receive(:gets).and_return("1\n")
      expect(ttt_input.mark).to eq([0, 0])
    end
    it 'can return [0, 1] when given 2' do
      allow(ttt_input).to receive(:gets).and_return("2\n")
      expect(ttt_input.mark).to eq([0, 1])
    end
    it 'can return [0, 2] when given 3' do
      allow(ttt_input).to receive(:gets).and_return("3\n")
      expect(ttt_input.mark).to eq([0, 2])
    end
    it 'can return [1, 0] when given 4' do
      allow(ttt_input).to receive(:gets).and_return("4\n")
      expect(ttt_input.mark).to eq([1, 0])
    end
    it 'can return [1, 1] when given 5' do
      allow(ttt_input).to receive(:gets).and_return("5\n")
      expect(ttt_input.mark).to eq([1, 1])
    end
    it 'can return [1, 2] when given 6' do
      allow(ttt_input).to receive(:gets).and_return("6\n")
      expect(ttt_input.mark).to eq([1, 2])
    end
    it 'can return [2, 0] when given 7' do
      allow(ttt_input).to receive(:gets).and_return("7\n")
      expect(ttt_input.mark).to eq([2, 0])
    end
    it 'can return [2, 1] when given 8' do
      allow(ttt_input).to receive(:gets).and_return("8\n")
      expect(ttt_input.mark).to eq([2, 1])
    end
    it 'can return [2, 2] when given 9' do
      allow(ttt_input).to receive(:gets).and_return("9\n")
      expect(ttt_input.mark).to eq([2, 2])
    end
  end
end
