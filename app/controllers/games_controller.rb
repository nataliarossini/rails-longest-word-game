require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a
    @grid = []
    @start_time = Time.now
    counter = 0
    while counter < 10
      counter += 1
      @grid << @letters.sample
    end
  end

  def score
    @grid = params[:grid]
    @given_word = params[:word]
    @end_time = Time.now
    @time_taken = @end_time - Time.parse(params[:start_time])
    @score = (@given_word.length * 100) - @time_taken.round
    url = "https://wagon-dictionary.herokuapp.com/#{@given_word}"
    word_check_request = URI.open(url).read
    @word_check = JSON.parse(word_check_request)
    if @word_check["found"] && word_in_grid(@given_word, @grid)
      @time = @time_taken
      @message = "Well done!"
    elsif @word_check["found"] == false#word_in_grid(@given_word, @grid)
      @score = 0
      @time = @time_taken
      @message = "not an english word!"
    else
      @score = 0
      @time = @time_taken
      @message = "Word not in the grid."
    end
    @message
  end

  def word_in_grid(word, grid)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= grid.count(letter) }
  end
end
