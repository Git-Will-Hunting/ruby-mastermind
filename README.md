# Mastermind

This digital representation of a code guessing game is created in ruby.

## Objective
The objective of Mastermind is for the codebreaker to guess the code created by the codemaker in a limited number of turns.

## Gameplay

- The codemaker creates a code using four pegs of different colors and hides it from the codebreaker.
- The codebreaker attempts to guess the code by placing four pegs of different colors into the board’s first row.
- The codemaker provides feedback by placing small pegs called “key pegs” on the board’s right-hand side. A black key peg is placed for each correct color and position, and a white key peg is placed for each correct color in the wrong position.
- The codebreaker uses the feedback to refine their guess and make a new one on the next row.
- The game continues until the codebreaker correctly guesses the code, or until they run out of turns.

## Rules

- The code is made up of four pegs of different colors, chosen from a set of six colors.
- A color can be used more than once in the code.
- The codebreaker has twelve turns to guess the code.
- The codebreaker can change their guess at any time before they submit it.
- The codemaker provides feedback after each guess by placing key pegs on the board’s right-hand side.
- The codebreaker can use logic and deduction to make educated guesses, but they cannot ask for help or use any external resources.
- The game can be played with two players, or one player can play against the computer.