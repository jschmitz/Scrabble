require_relative 'sc_tile'
require_relative 'sc_board'
require_relative 'sc_dictionary'
require_relative 'sc_tilerack'

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

  it "should compact the board" do
    board = Board.new(boardset)
    board.board[0].should == "111"
  end

  it "should build a board" do
    board = Board.new(boardset)
    board.row_count.should == 3
    board.column_count.should == 3
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
  
  it "should place a word on 1,0 and calculate score with multiplier" do
    b = Board.new(boardset)
    tile_scores = [1,2,1]
    b.score(tile_scores, 1, 0).should == 6
  end
  
  it "should find the best place to place a word within a row" do
    b = Board.new(boardset)
    tile_scores = [3,1]
    b.best_position(tile_scores, 1).should == 1
  end
  
  it "should find the best row and score of all rows to place a word" do
    b = Board.new(boardset)
    tile_scores = [2,3]
    b.best_row(tile_scores).should == 2
  end
  
  it "should find the best place to put a word on a given board in one direction" do
    b = Board.new(boardset)
    tile_scores = [2,3]
    final_result = b.best_placement(tile_scores)
    final_result["row"].should == 2
    final_result["column"].should == 1
    final_result["score"].should == 11
  end
  
  it "should find the best word on a given board in one direction" do
    b = Board.new(boardset)
    tile_scores_set = []
    tile_scores_set << [1,1]
    tile_scores_set << [2,3]
    final_result = b.best_word(tile_scores_set)
    final_result["word"].should == 1
    final_result["row"].should == 2
    final_result["column"].should == 1
    final_result["score"].should == 11
  end
  
  it "should respond to the is_rotated? method" do
    b = Board.new(boardset)
    b.is_rotated?.should == false
  end
  
  it "should rotate the board" do
    b = Board.new(["1 2 3", "4 5 6", "7 8 9"])
    b.rotate!
    b.is_rotated?.should == true
    b.board[0].should == "369"
    b.board[1].should == "258"
    b.board[2].should == "147"
  end
  
  it "should rotate the board back correctly" do
    b = Board.new(["1 2 3", "4 5 6", "7 8 9"])
    b.rotate!
    b.rotate!
    b.is_rotated?.should == false
    b.board[0].should == "123"
    b.board[1].should == "456"
    b.board[2].should == "789"
  end

  it "should find the best word on a given board in either direction" do
    b = Board.new(["1 1 1","1 2 1","1 9 3"])
    tile_scores_set = []
    tile_scores_set << [1,1]
    tile_scores_set << [2,3]
    final_result = b.board_answer(tile_scores_set)
    final_result["word"].should == 1
    final_result["row"].should == 1
    final_result["column"].should == 1
    final_result["score"].should == 31
    final_result["rotated"].should == true
  end
  
  it "should place the best word on the board" do
    b = Board.new(["1 1 1","1 2 1","1 9 3"])
    tile_scores_set = []
    tile_scores_set << [1,1]
    tile_scores_set << [2,3]
    words = []
    words << "no"
    words << "ya"
    final_result = b.board_answer(tile_scores_set)
    b.place_on_board(words[final_result["word"]], final_result["row"], final_result["column"], final_result["rotated"])
    b.best_board[0].should == "111"
    b.best_board[1].should == "1y1"
    b.best_board[2].should == "1a3"
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

describe Tilerack do
  let(:tile_input) { ["f5","o1","n2","e3"] }
  let(:dictionary_input) { ["one", "fon"] }
  
  it "should get the tile values for a given word" do
    tilerack = Tilerack.new(tile_input)
    tilerack.values_for_word("one").should == "123"
  end
  
  it "should get the tile values for all given words" do
    tilerack = Tilerack.new(tile_input)
    tilerack.values_for_words(dictionary_input).should == ["123","512"]
  end
  
end