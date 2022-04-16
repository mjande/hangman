class Game
  def initialize
    puts "Let's play Hangman!"
    @computer = Computer.new
  end
end

# Class that selects a solution and returns filled blanks after each guess
class Computer
  attr_accessor :solution

  def initialize
    words = File.open('google-10000-english-no-swears.txt', 'r').readlines
    words.map!(&:chomp).select! { |word| word.length >= 5 && word.length <= 12 }

    @solution = words.sample
  end
end
