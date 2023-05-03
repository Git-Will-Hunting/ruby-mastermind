<<<<<<< Updated upstream
require 'pry-byebug'
=======
# frozen_string_literal: true
>>>>>>> Stashed changes

require 'pry-byebug'

# mastermind game
# Author: git-will-hunting

# Objective: guess the secret code in 12 turns
# The code is a sequence of 4 colors
# The colors are red, green, blue, yellow, orange, purple
# The code can have duplicates
# The code is randomly generated
# The player has 12 turns to guess the code
# After each guess, the player is given feedback
# The feedback is the number of correct colors and positions
# The player wins if they guess the code in 12 turns

# nouns: Game, Board, Player, Peg, turn_count, guess, code, feedback, Key_peg
# verbs: player_guess, code_response, win, lose, play, start, end, generate_code,
# validate_guess, display, retry, quit, restart, help
# Game class, handles the game loop and input
class Game
  def initialize
    @turn_count = 0
    @mastermind = Mastermind.new
    @board = Board.new(self, @mastermind)
    @player = Player.new('Player 1', self, @board, @mastermind)
    @current_player = @player
    system 'clear' # clear the terminal
    puts 'Welcome to Mastermind! Press enter to continue'
    gets
    @mastermind.generate_code
    @board.display
  end

  attr_accessor :turn_count

  # the game loop
  def play
    # get the guess from the player until they win or lose
    @current_player.player_input until @turn_count == 11 || @board.win?
    if @board.win? # if they win
      puts 'Congrats you win!'
    else # if they lose
      puts 'Sorry you lose!'
    end
    # check if they want to play again
    play_again
  end

  # play again method
  def play_again
    puts 'Would you like to play again? (y/n)'
    case gets.chomp.downcase
    when 'y' || 'yes'
      restart
    when 'n' || 'no'
      quit
    else
      puts 'Invalid input'
      play_again
    end
  end

  # quit method to exit the game
  def quit
    puts 'Thanks for playing! Press enter to exit'
    gets
    exit
  end

  # help method - explains the rules of the game and how to play
  def help
    help_message = <<-HELP
    Mastermind is a code breaking game. The code is a sequence of 4 colours
    The colours are red, green, blue, yellow, orange, purple
    The code can have duplicates
    The code is randomly generated
    The player has 12 turns to guess the code
    After each guess, the player is given feedback
    The feedback is the number of correct colors and positions
    The player wins if they guess the code in 12 turns
    The player can enter 'quit' or 'q' to quit the game.
    The player can enter 'restart' or 'r' to restart the game.
    The player can enter 'help' or 'h' to display this help menu again.
    Please enter 4 colour names separated by spaces to make a guess.
    Press 'Enter' to continue
    HELP
    puts help_message
    gets
    @board.display
  end

  def restart
    # restart the game
    game = Game.new
    game.play
  end
end

# Board class
# creates the board as a series of rows of 4 columns
class Board
  # should contain the board
  def initialize(game, mastermind)
    @board = Array.new(12, Array.new(4))
    @feedback = Array.new(12, Array.new(4))
    @mastermind = mastermind
    @game = game
  end

  # allow the board to be read
  def display
    # display the board with feedback beside it
    # should be a series of rows of 8 columns
    # should be displayed in the terminal
    # should be updated after each turn
    system 'clear' # clear the terminal
    table_header
    @board.each_with_index do |row, index|
      feedback = @feedback[index]
      row_display = row.map { |color| sprintf("%-7s", color) }.join(' | ')
      feedback_display = feedback.map { |color| sprintf("%-7s", color) }.join(' | ')
      puts "| #{row_display} |-| #{feedback_display} |"
    end
    puts 'Please enter your guess or type help for more information'
  end

  # table header
  def table_header
    puts "Available colors: red, green, blue, yellow, orange, purple type 'help' for more information"
    guess_padding = " " * ((38 - 'Guess'.length) / 2)
    feedback_padding = " " * ((40 - 'Feedback'.length) / 2)
    puts "#{guess_padding} Guess #{guess_padding} |-| #{feedback_padding} Feedback #{feedback_padding}"
    puts '----------------------------------------|-|---------------------------------------'
  end

  # receive guess method
  def receive_guess(guess)
    @board[@game.turn_count] = guess
    receive_feedback(@mastermind.feedback)
    display
  end

  # receive feedback method
  def receive_feedback(feedback)
    @feedback[@game.turn_count] = feedback
  end

  # check if the player has won
  def win?
    @feedback.any? { |subarray| subarray.all?('black')}
  end
end

# Player class, handles the player actions and states
class Player
  # should contain name and guess
  def initialize(name, game, board, mastermind)
    @name = name
    @guess = []
    @game = game
    @board = board
    @mastermind = mastermind
  end
  attr_accessor :guess

  # player input method, handles the player input
  def player_input
    input = gets.chomp.downcase
    if input == 'quit' || input == 'q' # quit the game
      @game.quit
    elsif input == 'restart' || input == 'r' # restart the game
      @game.restart
    elsif input == 'help' || input == 'h' # display the help menu
      @game.help
    else # otherwise it is a guess and should be validated
      validate_guess(input)
    end
  end

  # validate guess method
  def validate_guess(guess_tmp)
    # should be a sequence of 4 colours separated by spaces
    # each value should be one of the 6 allowed colours
    # accepted values should be stored in the guess array
    guess_tmp.split(' ').each do |color|
      if %w[red green blue yellow orange purple].include?(color)
        @guess.push(color)
      else
        invalid_guess
      end
    end
    # should have 4 values in @guess
    if @guess.length != 4
      invalid_guess
    end
    valid_guess
  end

  #valid guess method
  def valid_guess
    @mastermind.code_response(@guess)
    @board.receive_guess(@guess)
    @game.turn_count += 1
    @guess = []
  end

  # invalid guess method
  def invalid_guess
    puts "Invalid guess, please enter 4 colours separated by spaces /n
              (red, green, blue, yellow, orange, purple)"
        @guess = []
        player_input
  end
end

# peg class, handles the color and position of each peg
class Peg
  def initialize(color, _position)
    @color = color
    @position = nil
  end
  # allow the position to be written
  attr_accessor :position
  # allow the color to be read
  attr_reader :color
end

# key peg class, represents the feedback from the code
class KeyPeg
end

# Mastermind class, sets the mystery code and handles the feedback
class Mastermind
  def initialize
    @code = []
    @feedback = []
  end

  attr_reader :feedback

  def generate_code
    # generate the code
    # should be a sequence of 4 colours
    # will be randomly generated
    # should be stored in the code array
    for i in 1..4
      @code.push(%w[red green blue yellow orange purple].sample)
    end
  end

  def code_response(guess)
    # clear the feedback array
    @feedback = []
    # check the guess against the code
    guess.each_with_index do |color, index|
      if @code[index] == color
        @feedback.push('black')
      elsif @code.include?(color)
        @feedback.push('white')
      else
        @feedback.push(' ')
      end
    end
  end
end

# Start the game
<<<<<<< Updated upstream
game = Game.new
game.play
=======
GameSettings.new
>>>>>>> Stashed changes
