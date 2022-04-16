# hangman

A version of the game Hangman (https://en.wikipedia.org/wiki/Hangman_(game)) played in the command line

Project specs from The Odin Project 
https://www.theodinproject.com/lessons/ruby-hangman

Built using Ruby 

Learning Goals
Better understanding of Ruby basics
Practice using serialization

Notes
Classes
1. Game
2. Player 

Program
1. Computer chooses word between 5 and 12 char for solution
  - Read file into array (on 5-12 char)
  - Randomly choose from array
  - Store choice in variable 
2. Computer stores solution for comparison later
2. Computer puts blanks for number of letters in solution
3. Round loop
  - Show player word filled in with previous guesses
  - Tell player how many guesses they have left
  - Prompt player to guess another letter
  - If letter has already been guessed (or isn't a valid letter), show error message
  - Check if guess is correct
  - Update blanks with guessed letter
  - Decrease guess counter by 1
4. Correct guess: Output solution and win message
5. After number of guesses: output solution and lose message

Later 
At beginning of game
1. Prompt player to start new game or load previous
2. If load previous: read Game Object from file

At beginning of round loop:
1. Prompt player to continue or save
2. If save, write Game object to a file (with overwrite)