module Exceptions
  class OutOfBoundsError < StandardError; end
  class IllegalMoveError < StandardError; end
  class UnknownMarkError < StandardError; end
  class PlayersAlreadyCreatedError < StandardError; end
end
