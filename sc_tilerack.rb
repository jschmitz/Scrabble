class Tilerack
  # this class is used to convert a word to its tiles values.
  def initialize(tiles)
    #tiles is array of 2char strings
    rack_tiles = []
    tiles.each do |tile|
      rack_tiles << Tile.new(tile)
    end
    @tiles = rack_tiles
  end
  
  def values_for_word(word)
    values = ""
    #word is a string
    word.each_char do |ch|
      @tiles.each do |tile|
        values = values + tile.score.to_s if tile.letter == ch
      end
    end
    values
  end
  
  def values_for_words(words)
    values = []
    words.each do |word|
      values << values_for_word(word)
    end
    values
  end
end