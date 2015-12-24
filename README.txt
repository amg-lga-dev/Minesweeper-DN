Mine Sweeper

Devopers and Designers: Andrew Grossfeld & Logan Allen

This repository contains the contents of a fully functioning, unique minesweeper. The game was created on Xcode and runs on most iOS platforms. The design of this app consists of a main introduction screen that branches out into three other views: a high score view, "how to play" view, and the game simulatio view. Best time scores are saved using core data.

Files:
>> IntroViewController:
	- Options to select the board size (8x8, 10x10, 12x12) as well as the difficulty (easy, med, hard)
	- "Scores" button displays a high score page modally
	- "How to Play" button displays instruction page modally
	- "Start" button displays the mine sweeper game pushed throught the navigation controller

>> HighScoreViewController:
	- Presented modally
	- Displays all of the scores for each board and it's respective difficulty levels
	- Dismisses back to IntroViewController
	- Ability to clear save high scores

>> HowToPlayViewController:
	- Directions on how to play the game
	- Small graphical display giving a taste of what the board looks like
	- Dismisses back to IntroViewController

>> GameViewController:
	- Presented via the navigation controller
	- Displays the board, best time for that board size and the respective level if applicable, and a current timer
	- AlertNotification popup to start the game
	- Initializes the MineSweeperGame class that simulates the game
	- AlertNotification when attempting to quit the game
	- Pause functionality that covers up the board and pauses the timer

>> MineSweeperGame:
	- The backbones of the game
	- Initializes the tiles, their location in the view in GameViewController, and the location and number of bombs
	- Contains methods for clicking -- displaying the bomb and ending the game, the number of bombs adjacent to the selected tile, or opening up the board nearby if no bombs are in close proximity
	- Makes user unable to click a 'mine' on the first click by redrawing the board
