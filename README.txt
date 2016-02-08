Mine Sweeper

Developers and Designers: Andrew Grossfeld & Logan Allen

This repository contains the contents of a fully functioning, unique minesweeper. The game was created on Xcode and runs on most iOS platforms. The design of this app consists of a main introduction screen that branches out into three other views: a settings and high score side view, a information side view, and the game simulation view. Best time scores are saved using core data.

Files:
>> ContainerViewController:
	-Contains IntroViewController as main view controller
	-Ability to toggle SidePanelViewController on left-side and InfoPanelViewController on right-side

>> IntroViewController:
	- "Start" button displays the mine sweeper game pushed through the 	navigation controller
	- Swiping left or “Settings” button in the top left displays SidePanelViewController
	- Swiping right or “Info” button in the top right displays InfoPanelViewController

>> SidePanelViewController:
	- Allows user to change the app theme: day or night
	- Gives options for selecting game difficulty and board size
	- Displays high scores and user info for selected board size and difficulty
	- “Clear Data” button allows clearing of saved high scores

>> InfoPanelViewController:
	- Shows information about developers and the app’s development
	- “Instructions” button that displays a PopViewController

>> PopViewController:
	- Presented modally
	- Directions on how to play the game
	- Small graphical display giving a taste of what the board looks like
	- Pops up in front of IntroViewController and dims the background
	- Supports swiping to change content and swipe down to dismiss the view
	- Dismisses back to InfoPanelViewController

>> GameViewController:
	- Presented via the navigation controller
	- Displays the board, best time for that board size and the respective level if applicable, and a 		current timer
	- AlertNotification popup to start the game
	- Initializes the MineSweeperGame class that simulates the game
	- AlertNotification when attempting to quit the game
	- Pause functionality that covers up the board and pauses the timer

>> MineSweeperGame:
	- The backbones of the game
	- Initializes the tiles, their location in the view in GameViewController, and the location and 		number of bombs
	- Contains methods for clicking -- displaying the bomb and ending the game, the number of bombs 		adjacent to the selected tile, or opening up the board nearby if no bombs are in close proximity
	- Makes user unable to click a 'mine' on the first click by redrawing the mine locations
