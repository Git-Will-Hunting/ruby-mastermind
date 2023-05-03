# Description: Contains all the text content for the game

controls_message = <<-CONTROLS
    Controls
    Type colours separated by a space to make a guess.
    The player can enter 'quit' or 'q' to quit the game.
    The player can enter 'restart' or 'r' to restart the game.
    The player can enter 'help' or 'h' to display this help menu again.
    The player can enter 'menu' or 'm' to return to the main menu.
    The player can enter 'pause' or 'p' to pause the game.
    Press 'Enter' to continue
    CONTROLS

welcome_message = <<-WELCOME
    Welcome to Mastermind!
    Press 'Enter' to continue
    WELCOME

main_menu = <<-MAINMENU
    Main Menu
    1. Player Select
    2. Set Max Turns
    3. Set Difficulty
    4. Start Game
    5. Rules
    6. Controls
    7. Quit
    MAINMENU

quit_message = <<-QUIT
    Thanks for playing!
    'Press enter to exit'
    QUIT

pause_message = <<-PAUSE
    Game paused
    Press 'h' for help
    Press 'm' for main menu
    Press 'r' to restart
    Press 'q' to quit
    Press 'Enter' to continue
    PAUSE

player_select = <<-PLAYERSELECT
    Player Select
    1. Player vs Computer
    2. Player vs Player
    3. Computer vs Player (not yet implemented)
    4. Computer vs Computer (not yet implemented)
    PLAYERSELECT

max_turns = <<-MAXTURNS
    Set Max Turns
    Enter a number between 1 and 12 (the default is 10)
    MAXTURNS

max_turns2 = "Max turns set to #{@game_settings[:max_turns]}, is this okay? (y/n)"

difficulty = <<-DIFFICULTY
    Set Difficulty
    1. Easy (default)
    2. Normal (Feedback is provided based on mastermind rules)
    3. Hard (No feedback when the colour is in the wrong position)
    DIFFICULTY

rules = <<-RULES
    Mastermind is a code breaking game. The code is a sequence of 4 colours
    The colours are red, green, blue, yellow, orange, purple
    The code can have duplicates of the same colour
    The player has 10 turns to guess the code (this can be changed in the main menu)
    After each guess, the player is given feedback
    Black means a selection was correct, white means there is a colour correct but not the right position
    The player wins if they guess the code in 10 turns
    RULES

win_message = player_count == 2 ? "Congrats #{@codebreaker.name} wins! Sorry #{@codemaker.name}, you lose!" : 'Congrats you win!'
lose_message = player_count == 2 ? "Congrats #{@codemaker.name} wins! Sorry #{@codebreaker.name}, you lose!" : 'Sorry you lose!'
