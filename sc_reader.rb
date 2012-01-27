require 'rubygems'
require 'json'
require 'pp'
require_relative 'sc_tile'
require_relative 'sc_board'
require_relative 'sc_dictionary'
require_relative 'sc_tilerack'

json = File.read('INPUT.json')
input = JSON.parse(json)
board = Board.new(input["board"])
dictionary = Dictionary.new(input["dictionary"])
tilerack = Tilerack.new(input["tiles"])

valid_words = dictionary.matches(tilerack.letters)
valid_words_points = tilerack.values_for_words(valid_words)
best_result = board.board_answer(valid_words_points)
best_board = board.place_on_board(valid_words[best_result["word"]],best_result["row"],best_result["column"], best_result["rotated"])
File.open('OUTPUT.txt', 'w') do |f|
  f.puts board.formatted_best_word
end