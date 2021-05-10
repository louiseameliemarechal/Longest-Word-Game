# require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    i = 1
    @letters = []
    while i <= 10
      @letters << ('A'..'Z').to_a.sample
      i += 1
    end
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    serialized_words = URI.open(url).read
    @words = JSON.parse(serialized_words)

    @word = @words["word"].upcase!.chars
    @letters = params[:letters].split
    includes = count_letter(@word, @letters)

    if includes && @words["found"]
      @result = "Well done !"
    elsif includes
      @result = "this is not an English word"
    elsif @words["found"] && includes == false
      @result = "you didn't use the right letters"
    else
      @result = "All wrong, try again, you dumb !"
    end
  end

  def home
  end

  private

  def count_letter(word, letters)
    word.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end
end


# <% if @words["word"].split("").include?(@letters) == false %>
#   <%= "Sorry your word doesn't include the right letters" %>


# <% elsif @words["found"] == false %>
#   <%= "Sorry but it is not an English word"%>
# <% end %>
