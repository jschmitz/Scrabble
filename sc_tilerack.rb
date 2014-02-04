class Tilerack
  # this class is used to convert a word to its tiles values.
  attr_reader :letters
  
  def initialize(tiles)
    #tiles is array of 2char strings
    rack_tiles = []
    rack_letters = ""
    tiles.each do |tile|
      t = Tile.new(tile)
      rack_tiles << t
      rack_letters += t.letter
    end
    @tiles = rack_tiles
    @letters = rack_letters
  end
  
  def values_for_word(word)
    values = ""
    #word is a string
    word.each_char do |ch|
      #don't put multiple values down for same letter
      found_char = false
      @tiles.each do |tile|
        values = values + tile.score.to_s if (tile.letter == ch and not found_char)
        if tile.letter == ch
          found_char = true
        end
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