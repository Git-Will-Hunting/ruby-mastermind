# frozen_string_literal: true

require 'pry-byebug'
require_relative 'text_content.rb'
require_relative 'game_logic.rb'
require_relative 'human_player.rb'

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
  def initialize(settings, config)
    @turn_count = 0
    @mastermind = Mastermind.new
    @board = Board.new(self, @mastermind)
    @player_count = settings[:player_count]
    @player1 = Player.new(settings[:player1], self, @board, config, @mastermind)
    @player2 = Player.new(settings[:player2], self, @board, config, @mastermind)
    @difficulty = settings[:difficulty]
    @max_turns = settings[:max_turns]
    @game_settings = config
    system 'clear' # clear the terminal
    if settings[:codemaker] == 'player1' # set the codemaker and codebreaker
      @codemaker = @player1
      @codebreaker = @player2
    else
      @codemaker = @player2
      @codebreaker = @player1
    end
    play
  end

  attr_accessor :turn_count

  # help method - explains the rules of the game and how to play
  def help
    puts rules_text
    puts controls_text
    puts 'Press enter to continue'
    gets
    @board.display
  end

  # create pause menu
  def pause_menu
    puts pause_menu_text
    case gets.chomp.downcase
    when 'q' || 'quit'
      quit
    when 'r' || 'restart'
      restart
    when 'h' || 'help'
      help
    when 'm' || 'main menu'
      main_menu
    else
      @board.display
    end
  end

  # the game loop
  def play
    if @player_count == 2
      puts "#{@codemaker.name} is the mastermind, please set a secret code so #{@codebreaker.name} can guess"
      @mastermind.pick_code
    else
      @mastermind.generate_code
    end
    @board.display
    # get the guess from the player until they win or lose
    @codebreaker.player_input until @turn_count == @max_turns || @board.win?
    if @board.win? # if they win
      if @player_count == 2
        puts "Congrats #{@codebreaker.name} wins! Sorry #{@codemaker.name}, you lose!"
      else
        puts 'Congrats you win!'
      end
    elsif @player_count == 2 # if they lose
      puts "Congrats #{@codebreaker.name} wins! Sorry #{@codemaker.name}, you lose!"
    else
      puts 'Sorry you lose!'
    end
    # check if they want to play again
    @game_settings.play_again
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
      row_display = row.map { |color| format('%-7s', color) }.join(' | ')
      feedback_display = feedback.map { |color| format('%-7s', color) }.join(' | ')
      puts "| #{row_display} |-| #{feedback_display} |"
    end
    puts 'Please enter your guess or type help for more information'
  end

  # table header
  def table_header
    puts "Available colors: red, green, blue, yellow, orange, purple type 'help' for more information"
    guess_padding = ' ' * ((38 - 'Guess'.length) / 2)
    feedback_padding = ' ' * ((40 - 'Feedback'.length) / 2)
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
    @feedback.any? { |subarray| subarray.all?('black') }
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


# Start the game
game_config = GameSettings.new
