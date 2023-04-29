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

# nouns: game, board, player, peg, turn_count, guess, code, feedback
# verbs: get_guess, set_feedback, win, lose, play, start, end
# Game class, handles the game loop and input
class Game
  def __init__
    @turn_count = 0
    @board = Board.new
    @player = Player.new('Player 1')
    @code = Mastermind.new
  end

  def play
    while turn_count < 12
      # get the guess from the player
      player.player_guess
    end
    # check the guess against the code
    # set the feedback
    # check if the player has won
    # if they have, end the game
    # if they haven't, increment the turn count
  end
end

# Board class
# creates the board as a series of rows of 4 columns
class Board
  # should contain the board
  def __init__
    @board = array.new(12, array.new(4))
  end
end

# Player class, handles the player actions and states
class Player
  # should contain name and guess
  def __init__(name)
    @name = name
    @guess = []
  end

  def player_guess
    # get the guess from the player
    # should be a sequence of 4 colours separated by spaces
    guess_tmp = gets.chomp.split(' ')
    # should be validated
    if guess_tmp.length != 4
      puts "Invalid guess, please enter 4 colours separated by spaces /n
            (red, green, blue, yellow, orange, purple)"
      player_guess
    # should be added to the guess array
    else
      @guess = guess_tmp
      @turn_count += 1
    end
  end
end

# peg class, handles the color and position of each peg
class Peg
  def __init__(color, _position)
    @color = color
    @position = nil
  end
  # allow the position to be written
  attr_accessor :position
  # allow the color to be read
  attr_reader :color
end

# colours class, handles the possible colours of the pegs
class Colours
end

# Mastermind class, sets the mystery code and handles the feedback
class Mastermind
  def __init__
    @code = []
    @feedback = []
  end

  def set_code
    # generate the code
    # should be a sequence of 4 colours
    # will be randomly generated but for now is hard coded
    # should be stored in the code array
    @code = ['red', 'green', 'blue', 'yellow']
  end
end

# Start the game
game = Mastermind.new
game.play
