Mine Sweeper

Created by: Andrew Grossfeld and Logan Allen

This minesweeper game was created on Xcode and runs on most iOS platforms. The design and implementation of this game is straightforward, with three view controllers, a data file holding the scores, and a game file that holds all of the game's functionality.

Files:
>> IntroViewController:
	- Options to select the board size (8x8, 10x10, etc.) as well as the difficulty (easy, med, hard).
	- Button to display a scores page modally
	- Button to start the game (navigates to the GameViewController)

>> HighScoreViewController:
	- Presented modally
	- Displays all of the scores for each board and it's respective difficulty levels
	- Dismisses back to IntroViewController

>> GameViewController:
	- Presented via the navigation controller
	- Displays the board, best time for that board size and the respective level, and a current timer
	- AlertNotification popup to start the game
	- Initializes the MineSweeperGame class that simulates the game

>> MineSweeperGame:
	- The backbones of the game
	- Initializes the tiles, their location in the view in GameViewController, and the location and number of bombs
	- Contains methods for clicking -- displaying the bomb and ending the game, the number of bombs adjacent to the selected tile, or opening up the board nearby if no bombs are in close proximity

>> Data.swift:
	- Hosts the score data