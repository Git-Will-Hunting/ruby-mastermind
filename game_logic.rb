# mastermind game logic

require_relative 'game_board'
require_relative 'game_input'
require_relative 'game_output'

class GameLogic
  include GameBoard
  include GameInput
  include GameOutput

  def initialize
    @board = GameBoard.new
    @input = GameInput.new
    @output = GameOutput.new
    @code = []
    @guess = []
    @guess_count = 0
  end

  def play
    @output.welcome
    @output.instructions
    @code = @input.code
    @output.code_set
    @output.code(@code)
    @output.game_start
    until @guess_count == 12
      @guess = @input.guess
      @output.guess(@guess)
      @guess_count += 1
      @output.guess_count(@guess_count)
      @output.feedback(@board.feedback(@guess, @code))
      if @board.feedback(@guess, @code) == ['b', 'b', 'b', 'b']
        @output.win
        break
      end
    end
    @output.lose
  end
end

GameLogic.new.play