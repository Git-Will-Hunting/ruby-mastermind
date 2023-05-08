module Player
    # purpose: contains the human player logic for the mastermind game
    # HumanPlayer
  class HumanPlayer
    # should contain name and guess
    def initialize(name)
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

  class ComputerPlayer
    # should contain name and guess
    def initialize(name)
      @name = name
      @guess = []
      @game = game
      @board = board
      @game_settings = config
      @mastermind = mastermind
    end

    #  create attribute accessors
    attr_accessor :name, :guess

    #  computer guess method
    def computer_guess
      # should be a sequence of 4 colours
      # will be randomly generated when not chosen by the player
      # should be stored in the guess array
      4.times do
        @guess.push(%w[red green blue yellow orange purple].sample)
      end
      valid_guess
    end

end
