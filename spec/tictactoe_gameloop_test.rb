require_relative '../lib/tictactoe_gameloop'
require_relative '../lib/exceptions'

describe TicTacToeGameLoop do
  subject(:gameloop) { described_class.new }
  context 'when initializing the gameloop' do
    it 'creates the expected collaborator objects, each of the proper class' do
      expect(gameloop.arbiter).to be_an_instance_of(TicTacToeArbiter)
      expect(gameloop.board).to be_an_instance_of(TicTacToeBoard)
      expect(gameloop.input).to be_an_instance_of(TicTacToeInput)
      expect(gameloop.output).to be_an_instance_of(TicTacToeOutput)
      expect(gameloop.players).to be_an_instance_of(Array)
    end
  end
  context 'when creating the players' do
    it 'calls Input to ask for the different players names' do
      expect(gameloop.input).to receive(:player_name).exactly(2).times
      gameloop.create_players
    end
    it 'it populates the players attribute with instances of Player' do
      allow(gameloop.input).to receive(:gets).and_return('AAA', 'BBB')
      expect { gameloop.create_players }.to change { gameloop.players }.from([]).to(array_including(instance_of(Player)))
    end
    it 'creates exactly two players' do
      allow(gameloop.input).to receive(:gets).and_return('AAA', 'BBB')
      expect { gameloop.create_players}.to change { gameloop.players.length }.from(0).to(2)
    end
    it 'raises an error if players are already created' do
      allow(gameloop.input).to receive(:gets).and_return('AAA', 'BBB')
      expect { 2.times { gameloop.create_players }}.to raise_error(Exceptions::PlayersAlreadyCreatedError)
    end
  end
  context 'when resetting the gameloop' do
    it 'resets the collaborator Board object' do
      expect { gameloop.reset }.to(change { gameloop.board })
    end
    it 'resets the collaborator Arbiter object' do
      expect { gameloop.reset }.to(change { gameloop.arbiter })
    end
  end
  context 'when running a turn of the game' do
    before { allow(gameloop.output).to receive(:print) }
    it 'asks the Output object to print the board' do
      allow(gameloop.input).to receive(:gets).and_return("1\n")
      board = gameloop.board
      output = gameloop.output
      expect(output).to receive(:show_board).with(board.spaces)
      gameloop.turn
    end
    it 'asks the Input object to get the space to be marked when the board is new' do
      input = gameloop.input
      keys_to_coords_map = {
        1 => [0, 0],
        2 => [0, 1],
        3 => [0, 2],
        4 => [1, 0],
        5 => [1, 1],
        6 => [1, 2],
        7 => [2, 0],
        8 => [2, 1],
        9 => [2, 2]
      }
      expect(input).to receive(:mark).with(keys_to_coords_map).and_return([0, 0])
      gameloop.turn
    end
    it 'asks the Input object to get the space to be marked when the board is not new' do
      input = gameloop.input
      gameloop.board[0, 0] = 'X'
      gameloop.board[1, 1] = 'O'
      gameloop.board[2, 2] = 'X'
      keys_to_coords_map = {
        2 => [0, 1],
        3 => [0, 2],
        4 => [1, 0],
        6 => [1, 2],
        7 => [2, 0],
        8 => [2, 1],
      }
      expect(input).to receive(:mark).with(keys_to_coords_map).and_return([1, 0])
      gameloop.turn
    end
    it 'marks the Board object' do
      allow(gameloop.input).to receive(:gets).and_return("1\n")
      expect { gameloop.turn }.to(change { gameloop.board.spaces })
    end
  end
  context 'when testing a normal run of the game'do
    before { allow(gameloop.output).to receive(:print) }
    it 'calls turn' do
      allow(gameloop.arbiter).to receive(:winner?).exactly(2).times.and_return(false, true)
      expect(gameloop).to receive(:turn).exactly(1).times
      gameloop.game
    end
    it 'queries the Arbiter to know if there is a winner' do
      expect(gameloop.arbiter).to receive(:winner?).and_return(true)
      gameloop.game
    end
    it 'queries the Arbiter if there is a winner until there is one' do
      allow(gameloop.arbiter).to receive(:winner?).exactly(6).times.and_return(false, false, false, false, false, true)
      expect(gameloop.input).to receive(:mark).exactly(5).times.and_return([0, 0], [2, 0], [1, 1], [2, 1], [2, 2])
      gameloop.game
    end
  end
end
