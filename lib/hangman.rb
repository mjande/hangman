# Class for gameplay functions like asking for input and saving game
class Game
  attr_accessor :guesses, :win, :used_letters
  attr_reader :computer

  def initialize
    puts "Let's play Hangman!"
    @computer = Computer.new
    @guesses = 6
    @win = false
    @used_letters = []
    until win == true
      play_round
    end
  end

  def play_round
    puts "\nYou have #{guesses} guesses remaining."
    computer.display_solution_partial
    puts "What is your next guess? (You may enter a letter
    or a whole word for your guess.)"
    guess = gets.chomp
    result = computer.check_guess(guess)
    round_result(result)
  end

  def round_result(result)
    case result
    when 'win'
      @win = true
      puts 'You win!'
    when false
      @guesses -= 1
    end
  end

  #put letter_check in computer class so it can work with other error messages better
  def letter_check(letter)
    if used_letters.none?(letter) && letter.length == 1
      used_letters.push(letter)
      p used_letters
    elsif letter.length == 1
      puts 'You already tried that letter! Try again!'
      play_round
    end
  end
end

# Class that selects a solution and returns filled blanks after each guess
class Computer
  attr_accessor :solution, :partial_solution

  def initialize
    words = File.open('google-10000-english-no-swears.txt', 'r').readlines
    words.map!(&:chomp).select! { |word| word.length >= 5 && word.length <= 12 }

    @solution = words.sample
    p solution

  end

  def display_solution_partial
    unless instance_variable_defined?(:@partial_solution)
      length = solution.length
      @partial_solution = Array.new(length, '_ ')
    end
    puts partial_solution.join
  end

  def check_guess(guess)
    result = check_word(guess) if guess.length > 1
    result = check_for_letter(guess) if guess.length == 1
    result
  end

  def check_word(word)
    'win' if word == solution
  end

  def check_for_letter(letter)
    if solution.include?(letter)
      replace_letters(letter)
    else
      false
    end
  end

  def replace_letters(letter)
    letter_index = solution.chars.each_index.select { |i| solution[i] == letter }
    letter_index.each { |i| partial_solution[i] = letter }
    if partial_solution.join == solution
      'win'
    else
      true
    end
  end

end

Game.new
