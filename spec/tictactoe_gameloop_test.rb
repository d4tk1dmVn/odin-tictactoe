require_relative '../lib/tictactoe_gameloop'

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
      board = gameloop.board
      output = gameloop.output
      expect(output).to receive(:show_board).with(board.spaces)
      gameloop.turn
    end
  end
end
"if i were following sandi metz unit testing ideas, to test the gameloop it should 1) test that after initialization, all objects that gameloop has to orchestrate are what is expected 2) test the reset, checking that all objects the gameloop orchestrates are back to square one 3) check that a turn can a.change the state of each object orchestrated (dont test the private methods that gameloop uses for this purpose, but rather the direct effects it has on the orchestrared objects)b.stub the calls made to the objects interfaces 4) check that game is a correct succession of turns. correct?1:52 PMBroadly yes, but a few refinementskey: value1 — correct. Test that collaborators are the right type/class after initialization. Dont test their internal state, just their identity.
2 — correct, but per Metz youd test the messages sent to collaborators rather than inspecting their state directly. So expect(board).to receive(:some_reset_signal) rather than checking boards contents afterward. The boards own tests cover what that message does.
3a — careful. Metz would say dont test state changes on collaborators from GameLoops tests — thats the collaborators own test responsibility. What GameLoop owns is that it sent the right messages. 3b is the right instinct and essentially supersedes 3a.
4 — this is the tricky one. Testing that #game produces a correct succession of turns risks over-specifying the loop. Per Metz, youd test that #game calls #turn and that it asks the arbiter the right questions, then stops. You dont test how many times in detail — thats implementation, not behavior. The termination condition (arbiter returns a winner) is what matters.
The underlying Metz principle threading through all of this: GameLoop only owns its outgoing messages. What the receivers do with them is not GameLoops test to write."
