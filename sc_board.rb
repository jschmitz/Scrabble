class Board

  attr_accessor :board
  attr_reader :best_board

  def initialize(board)
    @board = board
    @rotated = false
    @best_board = board
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
    temp_array = []
    if points.class.name.split("::").last == "String"
      temp_array = points.split(//)
      for i in (0..temp_array.size-1) do
        temp_array[i] = temp_array[i].to_i
      end
      points = temp_array
    end
    points.each do |point|
      score += @board[row][column].to_i * point
      column += 1
    end
    score
  end
  
  def best_position(points, row)
    best_position = 0
    best_score = 0
    for tile_placement in (0..spots_per_row(points)-1)
      if score(points, row, tile_placement) > best_score
        best_score = score(points, row, tile_placement)
        best_position = tile_placement
      end
    end
    best_position
  end
  
  def best_row(points)
    best_row = 0
    best_score = 0
    for rownum in (0..board.size-1) do
      if score(points, rownum, best_position(points, rownum)) > best_score
        best_row = rownum
        best_score = score(points, rownum, best_position(points, rownum))
      end
    end
    best_row
  end
  
  def best_placement(points)
    best_row = best_row(points)
    best_position = best_position(points, best_row)
    best_score = score(points, best_row, best_position)
    {"row" => best_row, "column" => best_position, "score" => best_score}
  end
  
  def best_word(point_set)
    best_result = {"word" => 0, "row" => 0, "column" => 0, "score" => 0}
    for word_index in (0..point_set.size-1) do
      points = point_set[word_index]
      best_placement = best_placement(points)
      if best_placement["score"] > best_result["score"]
        best_result["word"] = word_index
        best_result["score"] = best_placement["score"]
        best_result["row"] = best_placement["row"]
        best_result["column"] = best_placement["column"]
      end
    end
    best_result
  end
  
  def is_rotated?
    @rotated
  end
  
  def rotate!
    new_board = []
    if not is_rotated?
      (column_count-1).downto(0) do |colnum|
        rowtoadd = ""
        (0).upto(row_count-1) do |rownum|
          # go backwards, so start at last column
          rowtoadd += board[rownum][colnum]
        end
        new_board << rowtoadd
      end
    else
      (0).upto(column_count-1) do |colnum|
        rowtoadd = ""
          (row_count-1).downto(0) do |rownum|
          rowtoadd += board[rownum][colnum]
        end
        new_board << rowtoadd
      end
    end
    @board = new_board
    @best_board = new_board
    @rotated = !@rotated
  end
  
  def board_answer(point_set)
    best_result = {"word" => 0, "row" => 0, "column" => 0, "score" => 0, "rotated" => false}
    horiz_result = best_word(point_set)
    rotate!
    vert_result = best_word(point_set)
    rotate!
    if horiz_result["score"] >= vert_result["score"]
      best_result = horiz_result
    else
      best_result = vert_result
      best_result["rotated"] = true
    end
    best_result
  end
  
  def place_on_board(word, row, column, rotated)
    rotate! if rotated # rotate if you need to
    
    (0..word.size-1).each do |ch|
      @best_board[row][column + ch] = word[ch]
    end
    
    rotate! if rotated    #just rotate it back if you need to
    @best_board
  end
  
  def formatted_best_word
    best_formatted_board = []
    @best_board.each do |row|
      temp_row = row.split(//)
      best_formatted_board << temp_row.join(" ")
    end
    best_formatted_board 
  end
end