welcome_text = <<~WELCOME
  Welcome to Mastermind!
  In this game, you can either be the codebreaker or codemaker.
  The codemaker will set a code of four colors, which can be repeated.
  The codebreaker will have 12 turns to guess the code.
  After each guess, the codemaker will give feedback on the guess.
  The feedback will be in the form of black and white pegs.
  A black peg means that a color is correct and in the correct position.
  A white peg means that a color is correct but in the wrong position.
  No peg means that a color is not in the code.
  The codebreaker wins if they guess the code within 12 turns.
WELCOME

instructions_text = <<~INSTRUCTIONS
  Instructions:
  The codebreaker will guess the code by entering four colors.
  The colors are red, orange, yellow, green, blue, and purple.
  The codebreaker will enter the first letter of each color.
  For example, if the code is red, orange, yellow, and green,
  the codebreaker will enter 'royg'.
  The codemaker will then give feedback on the guess.
  The codebreaker will then enter another guess.
  This will continue until the codebreaker guesses the code or
  the codebreaker runs out of turns.
INSTRUCTIONS

code_set_text = <<~CODE_SET
  The code has been set.
  The codebreaker will now try to guess the code.
CODE_SET

game_start_text = <<~GAME_START
  The game has started.
  The codebreaker will now enter their first guess.
GAME_START

win_text = <<~WIN
  You win!  
WIN

lose_text = <<~LOSE
  You lost!
LOSE