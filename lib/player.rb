# Player class
class Player
  attr_reader :name, :mark
  attr_accessor :score

  def initialize(name, mark)
    @name = name
    @score = 0
    @mark = mark
  end
end
