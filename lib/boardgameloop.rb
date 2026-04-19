module BoardGameLoop
  def turn
    raise NotImplementedError
  end

  def run_one_game
    raise NotImplementedError
  end

  def reset
    raise NotImplementedError
  end
end
