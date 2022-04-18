require 'yaml'

# Class for gameplay functions like asking for input and saving game
class Game
  attr_accessor :guesses, :win, :used_letters
  attr_reader :computer

  def initialize
    puts "Let's play Hangman!"
    puts "Would you like to start a new game or load a previous one? (Type 'new' or 'load')."
    @computer = Computer.new
    start_choice = gets.chomp.downcase
    case start_choice
    when 'new'
      new_game
    when 'load'
      load_game
    else
      puts "Please type 'new' or 'load' to begin."
      new
    end
  end

  def new_game
    @guesses = 6
    @win = false
    @used_letters = []
    play_round until win == true || guesses.zero?
  end

  def load_game
    saved_game = File.open('saved_game.yml', 'r')
    data = YAML.load(saved_game)
    @guesses = data[:guesses]
    @used_letters = data[:used_letters]
    computer.solution = data[:solution]
    computer.partial_solution = data[:partial_solution]
    @win = false
    play_round until win == true || guesses.zero?
  end

  def play_round
    puts "\nYou have #{guesses} guesses remaining."
    computer.display_solution_partial
    puts 'What is your next guess?'
    puts "(You may enter a letter or a whole word for your guess, \nor type 'exit' to save and quit.)"
    guess = gets.chomp.downcase
    save_game if guess == 'exit'
    return unless letter_check(guess)

    result = computer.check_guess(guess)
    round_result(result)
  end

  def round_result(result)
    case result
    when 'win'
      @win = true
      puts 'You win!'
      puts "The word was #{computer.solution}."
    when false
      @guesses -= 1
      if guesses.zero?
        puts 'Sorry, you lose!'
        puts "The word was #{computer.solution}."
      end
    end
  end

  def letter_check(letter)
    if used_letters.none?(letter)
      used_letters.push(letter)
    else
      puts 'You already tried that one! Try again!'
      false
    end
  end

  # What needs to saved/serialized: guesses, used_letters, solution (computer),
  # partial_solution(computer)
  def serialize
    YAML.dump({
      guesses: @guesses,
      used_letters: @used_letters,
      solution: computer.solution,
      partial_solution: computer.partial_solution
    })
  end

  def save_game
    saved_game = File.new('saved_game.yml', 'w')
    data = serialize
    saved_game.write(data)
    saved_game.close
    exit
  end
end

# Class that selects a solution and returns filled blanks after each guess
class Computer
  attr_accessor :solution, :partial_solution

  def initialize
    words = File.open('google-10000-english-no-swears.txt', 'r').readlines
    words.map!(&:chomp).select! { |word| word.length >= 5 && word.length <= 12 }

    @solution = words.sample
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
    if word == solution
      'win'
    else
      false
    end
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
    letter_index.each { |i| partial_solution[i] = "#{letter} " }
    if partial_solution.join.delete(' ') == solution
      'win'
    else
      true
    end
  end
end

Game.new
