# frozen_string_literal: true

# purpose: contains the game logic for the mastermind game
module Mastermind
  # Game class, handles the game loop and the player input
  class Game
    def initialize
      # get the game settings
      @game_settings = GameSettings.new
      @mastermind = Mastermind.new
    end

    def play
      # generate the code
      @mastermind.generate_code
      # start the game loop
      loop do
        # get the player guess
        @mastermind.player_input
        # check the guess against the code
        @mastermind.code_response
        # display the feedback
        @mastermind.display_feedback
        # check the player has won
        break if @mastermind.win?
      end
    end
  end

  # Mastermind class, sets the mystery code and handles the feedback
  class Mastermind
    def initialize
      @code = []
      @feedback = []
    end

    # generate the code
    def generate_code
      # should be a sequence of 4 colours
      # will be randomly generated when not chosen by the player
      # should be stored in the code array
      if @game_settings.code_type == 'player'
        pick_code
      else
        4.times do
          @code.push(%w[red green blue yellow orange purple].sample)
        end
      end
    end

    # player code input
    def pick_code
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
      return unless @code.length != 4 # should have 4 values in @code

      puts 'Invalid code, please enter 4 colours separated by spaces \n'
      pick_code
    end

    # code response method
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

    def display_feedback
      # display the feedback
      puts @feedback.join(' ')
    end

    def win?
      # check victory condition
      @feedback.all? { |peg| peg == 'black' }
    end
  end
end
