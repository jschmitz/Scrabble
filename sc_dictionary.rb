class Dictionary
  attr_reader :words
  def initialize(words)
    @words = words
  end

  def matches(tileset)
    word_matches = []
    words.each do |word|
      word_matches << word if Dictionary.match?(tileset, word)      
    end
    return word_matches
  end

  def self.match?(tiles, word)
      match = false
      word.each_char do |ch|
        index = tiles.index ch
        return unless index
        tiles = Dictionary.remove_letter(tiles, ch)
      end
      # if you get through without finding a letter missing, then it's there
      true
  end

  def self.remove_letter(word, letter)
    word_arr = word.split(//)
    index = word_arr.index letter
    word_arr.delete_at index unless index.nil?
    return word_arr.join
  end

end