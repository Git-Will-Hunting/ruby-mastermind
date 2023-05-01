require 'pry-byebug'
# frozen_string_literal: true

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
# Game Settings class
class GameSettings
  def initialize
    @game_settings = {
      player_count: 1,
      player1: 'Player 1',
      player2: 'Player 2',
      codebreaker: 'player1',
      codemaker: 'player2',
      max_turns: 12,
      code_length: 4,
      colors: %w[red green blue yellow orange purple],
      difficulty: 'easy'
    }
    main_menu
  end

  # player selection method
  def player_selection
    system 'clear' # clear the terminal
    puts "Please select number of players: \n 1. 1 player \n 2. 2 player \n 3. Computer codebreaker vs player (coming soon)"
    input = gets.chomp.downcase
    case input
    when '1'
      @game_settings[:player_count] = 1 # set player count to 1
      @game_settings[:player1] = create_players
      main_menu
    when '2'
      @game_settings[:player1] = create_players
      @game_settings[:player2] = create_players
      @game_settings[:player_count] = 2 # set player count to 2
      puts 'Who will be the mastermind? (1/2)'
      mastermind = gets.chomp.downcase
      case mastermind
      when '1'
        @game_settings[:codemaker] = 'player1'
        @game_settings[:codebreaker] = 'player2'
      when '2'
        @game_settings[:codemaker] = 'player2'
        @game_settings[:codebreaker] = 'player1'
      else
        puts 'Invalid input'
        player_selection
      end
      main_menu
    when '3'
      puts 'Coming soon to a terminal near you!'
      puts 'Press enter to continue'
      gets
      main_menu
    else
      puts 'Invalid input'
      player_selection
    end
  end

  # create players
  def create_players
    puts 'Please enter your name'
    name = gets.chomp
    return name unless name.empty?

    puts 'Invalid input'
    create_players
  end

  # set difficulty
  def set_difficulty
    puts 'difficulty settings coming soon!'
    puts "Please select difficulty: \n 1. Easy (extra feedback) \n 2. Normal \n 3. Hard (Limited feedback)"
    input = gets.chomp.downcase
    case input
    when '1'
      @game_settings[:difficulty] = 'easy'
    when '2'
      @game_settings[:difficulty] = 'normal'
    when '3'
      @game_settings[:difficulty] = 'hard'
    else
      puts 'Invalid input'
      set_difficulty
    end
    main_menu
  end

  # set max turns
  def max_turns
    puts 'Please enter max turns (default is 12)'
    input = gets.chomp
    @game_settings[:max_turns] = input.to_i unless input.empty?
    puts "Max turns set to #{@game_settings[:max_turns]}, is this okay? (y/n)"
    case gets.chomp.downcase
    when 'y' || 'yes'
      main_menu
    else
      max_turns
    end
  end

  # play again method
  def play_again
    puts 'Would you like to play again? (y\n)'
    case gets.chomp.downcase
    when 'y' || 'yes'
      restart
    when 'n' || 'no'
      main_menu
    else
      puts 'Invalid input'
      play_again
    end
  end

  # main menu method
  def main_menu
    system 'clear' # clear the terminal
    puts "Welcome to Mastermind! \n\n 1. Player selection \n 2. Max turns \n 3. Difficulty \n 4. Start \n 5. Quit"
    input = gets.chomp.downcase
    case input
    when '1'
      player_selection
    when '2'
      max_turns
    when '3'
      set_difficulty
    when '4'
      restart
    when '5'
      quit
    else
      puts 'Invalid input'
      main_menu
    end
  end

  # quit method to exit the game
  def quit
    puts 'Thanks for playing! Press enter to exit'
    gets
    exit
  end

  def restart
    # restart the game
    game = Game.new(@game_settings, self)
    game.play
  end
end

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
    help_message = <<-HELP
    Mastermind is a code breaking game. The code is a sequence of 4 colours
    The colours are red, green, blue, yellow, orange, purple
    The code can have duplicates
    The player has 12 turns to guess the code
    After each guess, the player is given feedback
    Black means the guess is correct, white means the colour is in the code but not the right position
    The player wins if they guess the code in 12 turns
    The player can enter 'quit' or 'q' to quit the game.
    The player can enter 'restart' or 'r' to restart the game.
    The player can enter 'help' or 'h' to display this help menu again.
    The player can enter 'menu' or 'm' to return to the main menu.
    The player can enter 'pause' or 'p' to pause the game.
    Press 'Enter' to continue
    HELP
    puts help_message
    gets
    @board.display
  end

  # create pause menu
  def pause_menu
    puts "Press enter to continue \n\n enter 'q' to quit \n enter 'r' to restart \n enter 'h' for help \n enter 'm' for main menu"
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

# Player class, handles the player actions and states
class Player
  # should contain name and guess
  def initialize(name, game, board, config, mastermind)
    @name = name
    @guess = []
    @game = game
    @board = board
    @game_settings = config
    @mastermind = mastermind
  end

  #  create attribute accessors
  attr_accessor :name, :guess

  # player input method, handles the player input
  def player_input
    input = gets.chomp.downcase
    if %w[quit q].include?(input) # quit the game
      @game_settings.quit
    elsif %w[restart r].include?(input) # restart the game
      @game_settings.restart
    elsif %w[help h].include?(input) # display the help menu
      @game.help
    elsif %w[menu m].include?(input) # return to the main menu
      @game_settings.main_menu
    elsif %w[pause p].include?(input) # pause the game
      @game.pause
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
    invalid_guess if @guess.length != 4
    valid_guess
  end

  # valid guess method
  def valid_guess
    @mastermind.code_response(@guess)
    @board.receive_guess(@guess)
    @game.turn_count += 1
    @guess = []
  end

  # invalid guess method
  def invalid_guess
    puts "Invalid guess, please enter 4 colours separated by spaces \n
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

  # pick code method
  def pick_code
    # should be a sequence of 4 colours
    # should be picked by the mastermind player
    # should be stored in the code array
    puts 'Please enter your code'
    @code = [] # clear the code array
    gets.chomp.downcase.split(' ').each do |color|
      if %w[red green blue yellow orange purple].include?(color)
        @code.push(color)
      else
        puts 'Invalid code, please enter 4 colours separated by spaces \n'
        pick_code
      end
    end
    # should have 4 values in @code
    return unless @code.length != 4

    puts 'Invalid code, please enter 4 colours separated by spaces \n'
    pick_code
  end

  # generate code method
  def generate_code
    # generate the code
    # should be a sequence of 4 colours
    # will be randomly generated
    # should be stored in the code array
    4.times do
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
game_config = GameSettings.new
