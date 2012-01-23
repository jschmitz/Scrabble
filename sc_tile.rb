class Tile 

  def initialize(tile)
    @tile = tile
  end

  def letter
    @tile[0]
  end

  def score
    @tile[1].to_i
  end
end