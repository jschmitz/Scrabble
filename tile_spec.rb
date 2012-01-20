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
      tiles.empty?
  end

  def self.remove_letter(word, letter)
    word_arr = word.split(//)
    index = word_arr.index letter
    word_arr.delete_at index unless index.nil?
    return word_arr.join
  end

end

class Board

  attr_accessor :board

  def initialize(board)
    @board = board
    for rownum in (0..board.size-1) do
      @board[rownum] = @board[rownum].gsub(" ","")
    end
  end

  def row_count
    @board.size
  end

  def column_count
    @board[0].gsub(" ", "").size
  end

  def spots_per_row(word)
    column_count - word.size + 1
  end

  def score(points, row, column)
    score = 0
    points.each do |point|
      score += @board[row, column].to_i * point
      column += 1
    end
    score
  end
end

describe Tile do

  let(:tile_input) { "f5" }

  it "should have a letter and number" do
    input = 'f5'
    tile = Tile.new(input)
    tile.letter.should == 'f'
  end

  it "should have a tile score" do
    Tile.new(tile_input).score.should == 5
  end
end

describe Board do
  let(:boardset) { ["1 1 1", "1 2 1", "1 1 3"] }

  it "shoudl compact the board" do
    board = Board.new(boardset)
    board.board[0].should == "111"
  end

  it "should build a board" do
    board = Board.new(boardset)
    board.row_count.should == 3
    board.column_count.should == 3
   #   board.
  end

  it "should know how many times a word can go in a row" do
    board = Board.new(boardset)
    word = "to"

    board.spots_per_row(word).should == 2
  end

  it "should place a word on 0,0 and calculate the score" do
    b = Board.new(boardset)
    tile_scores = [1,1,1]
    b.score(tile_scores, 0, 0).should == 3
  end
end

describe Dictionary do
  it "should match if the tiles provided can complete the word in the dictionary" do
    tiles = "oen"
    word = "one"
    Dictionary.match?(tiles, word).should == true
  end

  it "should take a group of letters and match on a word in the dictionary" do
    words = ["one", "two"]
    letters = "oen"
    dick = Dictionary.new(words)
    dick.matches(letters).should == ["one"]
  end

  it "should return multiple words" do
    words = ["one", "eno", "two"]
    word = "oen"
    d = Dictionary.new(words)
    d.matches(word).should == ["one", "eno"]
  end

  it "should not return if it's got multiple of the same letter" do
    words = ["onne"]
    word = "oen"
    d = Dictionary.new(words)
    d.matches(word).should == []
  end

  it "loads words into the dictionary" do
    words = ["one", "two"]
    d = Dictionary.new(words)
    d.words[0].should == "one"
    d.words[1].should == "two"
  end

  it "should remove single character from a word" do 
    word = "one"
    letter = "n"
    Dictionary.remove_letter(word, letter).should == "oe"
  end
end
