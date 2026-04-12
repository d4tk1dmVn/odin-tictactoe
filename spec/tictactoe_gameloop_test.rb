require_relative '../lib/tictactoe_gameloop'
require_relative '../lib/exceptions'

describe TicTacToeGameLoop do
  let(:gameloop) do
    allow_any_instance_of(TicTacToeInput).to receive(:player_name).and_return('AAA', 'BBB')
    allow_any_instance_of(TicTacToeOutput).to receive(:show_board)
    described_class.new
  end
  context 'when initializing the gameloop' do
    it 'creates the expected collaborator objects, each of the proper class' do
      expect(gameloop.arbiter).to be_an_instance_of(TicTacToeArbiter)
      expect(gameloop.board).to be_an_instance_of(TicTacToeBoard)
      expect(gameloop.input).to be_an_instance_of(TicTacToeInput)
      expect(gameloop.output).to be_an_instance_of(TicTacToeOutput)
      expect(gameloop.players).to be_an_instance_of(Array)
      expect(gameloop.players.length).to eq(2)
      expect(gameloop.players).to all(be_an_instance_of(Player))
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
    it 'asks the Output object to print the board' do
      allow(gameloop.input).to receive(:gets).and_return("1\n")
      board = gameloop.board
      output = gameloop.output
      expect(output).to receive(:show_board).with(board.spaces)
      gameloop.turn(0)
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
      gameloop.turn(0)
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
        8 => [2, 1]
      }
      expect(input).to receive(:mark).with(keys_to_coords_map).and_return([1, 0])
      gameloop.turn(0)
    end
    it 'asks the first player to give their mark on the even turns' do
      allow(gameloop.input).to receive(:mark).and_return([0, 0])
      expect(gameloop.players[0]).to receive(:mark).and_return('X')
      gameloop.turn(0)
    end
    it 'asks the second player to give their mark on the odd turns' do
      allow(gameloop.input).to receive(:mark).and_return([0, 1])
      expect(gameloop.players[1]).to receive(:mark).and_return('O')
      gameloop.turn(1)
    end
    it 'marks the Board object' do
      allow(gameloop.input).to receive(:gets).and_return("1\n")
      expect { gameloop.turn(0) }.to(change { gameloop.board.spaces })
    end
  end
  context 'when testing a normal run of the game' do
    it 'calls turn' do
      allow(gameloop.arbiter).to receive(:winner?).exactly(2).times.and_return(false, true)
      expect(gameloop).to receive(:turn).exactly(1).times.with(0)
      gameloop.run_one_game
    end
    it 'queries the Arbiter to know if there is a winner' do
      expect(gameloop.arbiter).to receive(:winner?).and_return(true)
      gameloop.run_one_game
    end
    it 'queries the Arbiter if there is a winner until there is one' do
      allow(gameloop.arbiter).to receive(:winner?).exactly(6).times.and_return(false, false, false, false, false, true)
      expect(gameloop.input).to receive(:mark).exactly(5).times.and_return([0, 0], [2, 0], [1, 1], [2, 1], [2, 2])
      gameloop.run_one_game
    end
    it 'since it increments the counter, players marks should be different in between turns' do
      allow(gameloop.arbiter).to receive(:winner?).exactly(3).times.and_return(false, false, true)
      allow(gameloop.input).to receive(:mark).exactly(2).times.and_return([0, 0], [0, 1])
      expect(gameloop.players[0]).to receive(:mark).and_return('X')
      expect(gameloop.players[1]).to receive(:mark).and_return('O')
      gameloop.run_one_game
    end
    it 'queries the Board if it is full' do
      expect(gameloop.board).to receive(:full?).and_return(true)
      gameloop.run_one_game
    end
    it 'queries the Board if it is full until it is (provided there is no winner)' do
      moves = [[0, 0], [2, 2], [0, 2], [2, 0], [2, 1], [0, 1], [1, 1], [1, 0], [1, 2]]
      allow(gameloop.arbiter).to receive(:winner?).exactly(10).times.and_return(*Array.new(10, false))
      expect(gameloop.input).to receive(:mark).exactly(9).times.and_return(*moves)
      expect(gameloop.board).to receive(:full?).exactly(10).times.and_return(*Array.new(9, false), true)
      gameloop.run_one_game
    end
  end
  context 'when testing the main loop' do
    it 'queries the Arbiter to know if there is a tie' do
      allow(gameloop).to receive(:run_one_game).and_return(nil)
      allow(gameloop.output).to receive(:show_scores)
      expect(gameloop.arbiter).to receive(:tie?)
      gameloop.main
    end
    it 'queries the Arbiter to know who the winner is' do
      allow(gameloop).to receive(:run_one_game).and_return(nil)
      allow(gameloop.output).to receive(:show_scores)
      expect(gameloop.arbiter).to receive(:winner).exactly(2).times
      gameloop.main
    end
    it 'raises ONLY the score of player 1 if they win' do
      allow(gameloop).to receive(:run_one_game).and_return(nil)
      allow(gameloop.output).to receive(:show_scores)
      allow(gameloop.arbiter).to receive(:tie?).and_return false
      allow(gameloop.arbiter).to receive(:winner).and_return 'X'
      expect { gameloop.main }.to(change { gameloop.players[0].score }.from(0).to(1))
      expect { gameloop.main }.not_to(change { gameloop.players[1].score })
    end
    it 'raises ONLY the score of player 2 if they win' do
      allow(gameloop).to receive(:run_one_game).and_return(nil)
      allow(gameloop.output).to receive(:show_scores)
      allow(gameloop.arbiter).to receive(:tie?).and_return false
      allow(gameloop.arbiter).to receive(:winner).and_return 'O'
      expect { gameloop.main }.to(change { gameloop.players[1].score }.from(0).to(1))
      expect { gameloop.main }.not_to(change { gameloop.players[0].score })
    end
    it 'calls #run_one_game' do
      allow(gameloop.output).to receive(:show_scores)
      expect(gameloop).to receive(:run_one_game)
      gameloop.main
    end
    it 'calls #show_scores' do
      expect(gameloop.output).to receive(:show_scores)
      gameloop.main
    end
  end
end
