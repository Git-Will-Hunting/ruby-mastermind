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
    puts player_select
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
    when '4'
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
    puts difficulty_select
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
    puts max_turns_select
    input = gets.chomp
    @game_settings[:max_turns] = input.to_i unless input.empty?
    puts max_turns_confirm
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
    puts main_menu_text
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
    puts quit_message
    gets
    exit
  end

  def restart
    # restart the game
    game = Game.new(@game_settings, self)
    game.play
  end
end
