module Arbiter
  def winner?
    raise NotImplementedError
  end

  def winner
    raise NotImplementedError
  end

  def tie?
    raise NotImplementedError
  end
end
