require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = []
    vowels = %w[A E I O U Y]
    consonants = ('A'..'Z').to_a - vowels
    5.times do
      @letters << consonants.sample
      @letters << vowels.sample
    end
  end

  def test_vs_grid?(attempt, grid)
    attempt = attempt.upcase.split('')
    grid = grid.upcase.split('')
    grid.each { |letter| attempt.delete_at(attempt.index(letter)) if attempt.index(letter) }
    attempt.empty?
  end

  def api_answer(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    JSON.parse(attempt_serialized)
  end

  def score
    @attempt = params[:answer].upcase
    @grid = params[:letters]
    if api_answer(@attempt)['found'] && test_vs_grid?(@attempt, @grid)
      @valid = true
      @score = @attempt.length**2
      session[:score].nil? ? session[:score] = @score : session[:score] += @score
    elsif api_answer(@attempt)['found']
      @valid = false
      @english = true
    else
      @valid = false
      @english = false
    end
  end
end
