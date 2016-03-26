//
//  GameViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/2/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate {
    var game: MineSweeperGame!
    var introVC: IntroViewController!
    var gameSize: Int!
    var gameLevel: Int!
    var scrollView: UIScrollView!
    var boardView: UIView!
    var screenCover: UIView!
    var backgroundImage: UIImageView!
    var flagsLeft: Int = 100
    var flagNumber: UILabel!
    var timer: NSTimer!
    var time: Int = 0
    var timeLabel: UILabel!
    var bestTimeLabel: UILabel!
//    var endLabel: UILabel!

    // View did load
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blackColor()
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        
        createBottomImage(theme)
        createScrollViews()
        createScreen(theme)
        createFlag()
        
        // Create actual mine sweeper game
        game = MineSweeperGame(gameSize: gameSize, gameLevel: gameLevel, vc: self)
        activateTiles()
        
        // Set the theme
        self.view.backgroundColor = Style.foundationColor
        self.navigationController?.navigationBar.barTintColor = Style.navBar
        
        // Popup alert to start the timer
        let alertController = UIAlertController(title: "Ready to Sweep?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Mine!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // action to happen when proceed is selected
            self.game.initTimer()
        }))
        alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // Set navigation bar items
    override func viewWillAppear(animated: Bool) {
        time = 0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " Quit", style: .Plain, target: self, action: #selector(GameViewController.quit(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .Plain, target: self, action: #selector(GameViewController.pauseButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = Style.textColor
        self.navigationItem.rightBarButtonItem?.tintColor = Style.textColor
    }
    
    // Zoom in on boardView when pinched
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return boardView
    }
    
    // Create bottom image with shadows
    func createBottomImage(theme: String){
        let bottomImage = UIImageView(frame: CGRect(x: 0, y: self.view.bounds.height - 140, width: self.view.bounds.width, height: 140))
        bottomImage.image = UIImage(named: "mountains.png")
        bottomImage.layer.opacity = 1.0
        bottomImage.layer.shadowColor = UIColor.blackColor().CGColor
        bottomImage.layer.shadowOffset = CGSizeMake(3, 2)
        bottomImage.layer.shadowOpacity = 0.6
        bottomImage.layer.shadowRadius = 2
        self.view.addSubview(bottomImage)
    }
    
    // Create scroll view and board view on top of it
    func createScrollViews(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.width))
        scrollView.backgroundColor = UIColor.grayColor()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        if (gameSize > 10){
            scrollView.maximumZoomScale = 1.5
        }else{
            scrollView.maximumZoomScale = 1.0
        }
        boardView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        boardView.backgroundColor = Style.textColor
        scrollView.addSubview(boardView)
        self.view.addSubview(scrollView)
    }
    
    // Create pause screen cover
    func createScreen(theme: String){
        screenCover = UIView(frame: CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.width))
        screenCover.layer.shadowOpacity = 0.4
        screenCover.layer.shadowOffset = CGSizeMake(0, 5)
        screenCover.layer.shadowRadius = 3
        screenCover.backgroundColor = UIColor.clearColor()
        screenCover.hidden = true
        screenCover.layer.shadowColor = Style.textColor.CGColor
        let w = screenCover.bounds.width
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        let mine = UIImageView(frame: CGRect(x: w/4, y: 65, width: w/2, height: w/2))
        mine.image = UIImage(named: "landmine")
//        mine.layer.shadowOpacity = 0.6
//        mine.layer.shadowOffset = CGSizeMake(2, 2)
//        mine.layer.shadowRadius = 2
        let caption = UILabel(frame: CGRect(x: 5, y: w-45, width: w-10, height: 30))
        caption.text = "Take a breather..."
        caption.font = UIFont(name: "Gill Sans", size: 24)
        caption.textColor = Style.textColor
        caption.textAlignment = .Center
//        caption.layer.shadowColor = UIColor.blackColor().CGColor
//        caption.layer.shadowOpacity = 0.6
//        caption.layer.shadowOffset = CGSizeMake(1,1)
//        caption.layer.shadowRadius = 1;
        if theme == "Day"{
            backgroundImage.image = UIImage(named: "sky")
        }else{
            backgroundImage.image = UIImage(named: "nightSky")
        }
        backgroundImage.addSubview(mine)
        backgroundImage.addSubview(caption)
        screenCover.addSubview(backgroundImage)
        self.view.addSubview(screenCover)
        view.sendSubviewToBack(screenCover)
    }
    
    // Create flag image and counter
    func createFlag(){
        let flagImage = UIImageView(frame: CGRect(x: 10, y: self.view.bounds.height - 35, width: 25, height: 25))
        flagImage.image = UIImage(named: "flag")
        flagImage.layer.shadowRadius = 2
        flagImage.layer.shadowColor = UIColor.blackColor().CGColor
        flagImage.layer.shadowOffset = CGSizeMake(2, 2)
        flagImage.layer.shadowOpacity = 0.7
        flagNumber = UILabel(frame: CGRect(x: 40, y: self.view.bounds.height - 35, width: 50, height: 30))
        flagNumber.font = UIFont(name: "Gill Sans", size: 18)
        flagNumber.textColor = UIColor.blackColor()
        if gameSize<=10{
            flagsLeft = 100
        }else{
            flagsLeft = 150
        }
        updateFlagCounter()
        view.addSubview(flagImage)
        view.addSubview(flagNumber)
    }
    
    // Add actions to tiles
    func activateTiles(){
        for tile in game.tiles {
            tile.addTarget(self, action: #selector(GameViewController.tilePressed(_:)), forControlEvents: .TouchUpInside)
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(GameViewController.tileLongPressed(_:)))
            longPress.minimumPressDuration = 0.5
            tile.addGestureRecognizer(longPress)
        }
    }
    
    // Returns key for current board size and difficulty
    func getKey() -> String{
        var diff: String = ""
    
        if gameLevel == 0{
            diff = "Easy"
        }else if gameLevel == 1{
            diff = "Medium"
        }else{
            diff = "Hard"
        }
        
        return "\(gameSize)\(diff)"
    }
    
    // Updates text showing best time and attempts
    func updateData(memo: String){
        let key: String = getKey()
        if memo == "quit" || game.loseOrWin == 1{
            // Add to total losses
            var losses = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Fails") as! Int
            losses += 1
            NSUserDefaults.standardUserDefaults().setValue(losses, forKey: "\(key)Fails")
        }else{
            // Add to total wins
            var wins = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Wins") as! Int
            wins += 1
            NSUserDefaults.standardUserDefaults().setValue(wins, forKey: "\(key)Wins")
        }
    }
    
    // Called when the quit nav bar item is pressed
    func quit(sender: AnyObject){
        // Quit automatically if game is already lost
        if game.loseOrWin != 0{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            // Pause game if not already paused
            let alreadyPaused = (game.pauseGame == 1)
            if !alreadyPaused { game.pauseGame = 1 }
            
            // Popup alert to double-check if use wants to quit
            let alertController = UIAlertController(title: "Are you sure you want to quit?", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Quit", style: .Destructive, handler: { (action) -> Void in
                // What happens when quit is pressed in the alert
                self.updateData("quit")
                self.navigationController?.popToRootViewControllerAnimated(true)
                self.introVC?.containerVC?.currentState = .IntroShowing
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
                // Do nothing if cancel is pressed in alert
                // Unpause game if wasn't already paused
                if !alreadyPaused {self.game.pauseGame = 0 }
            }))
            alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Called when pause button is pressed
    func pauseButtonPressed(sender: AnyObject){
        if game.loseOrWin == 0{
            if self.navigationItem.rightBarButtonItem?.title == "Pause"{
                // Pause game and display screen cover
                game.pauseGame = 1
                self.navigationItem.rightBarButtonItem?.title = "Resume"
                screenCover.hidden = false
                view.bringSubviewToFront(screenCover)
            }else{
                // Unpause game and hide screen cover
                game.pauseGame = 0
                self.navigationItem.rightBarButtonItem?.title = "Pause"
                screenCover.hidden = true
                view.sendSubviewToBack(screenCover)
            }
        }
    }
    
    // Recreate game, timer, and flags.
    func recreateGame(){
        self.time = 0
        self.timeLabel.removeFromSuperview()
        self.bestTimeLabel.removeFromSuperview()
        self.game = MineSweeperGame(gameSize: gameSize, gameLevel: gameLevel, vc: self)
        if gameSize<=10{
            self.flagsLeft = 100
        }else{
            self.flagsLeft = 150
        }
        updateFlagCounter()
        activateTiles()
        self.game.initTimer()
    }
    
    /* Called when player wins or loses.
       Notification Alert to play again or quit. */
    func playAgainNotification(result: String, msg: String){
        let alertController = UIAlertController(title: result, message: msg, preferredStyle: .Alert)
        alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
        let playAgain = UIAlertAction(title: "Play Again", style: .Default, handler: { (action) -> Void in
            // Reinitialize minesweepergame
            self.recreateGame()
        })
        let exit = UIAlertAction(title: "Exit", style: .Default, handler: { (action) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.introVC?.containerVC?.currentState = .IntroShowing
        })
        alertController.addAction(playAgain)
        alertController.addAction(exit)
        alertController.preferredAction = playAgain
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Resets the board until the first tile clicked is not a bomb
    func resetBoard(tile: Tile){
        //print("resetting")
        resetTiles()
        game.numMines = 0
        game.setBombs()
        if tile.isBomb{
            resetBoard(tile)
        }
        game.setNumbers()
    }
    
    // Reset tiles to "nil" initial state
    func resetTiles(){
        for tile in game.tiles{
            tile.number = -2
            tile.isBomb = false
            tile.flipped = false
            tile.marked = false
            tile.backgroundColor = Style.unflippedTile
            tile.layer.borderColor = Style.tileBorder.CGColor
            tile.layer.borderWidth = 1.0
        }
    }
    
    /* Flip over an uncovered tile
       Displays number of adjacent mines if the tile itself is not a mine */
    @IBAction func tilePressed(sender: UIButton) {
        if game.pauseGame == 0{
            let tile = sender as! Tile
            
            // Reset Game Board if first tile pressed is a bomb
            if game.firstTilePressed == 0{
                //print("First tile pressed")
                if tile.isBomb{
                    //print("Tile Number: \(tile.number)")
                    resetBoard(tile)
                }
                game.firstTilePressed = 1
            }
            
            if tile.marked == true{
                // Clear the flag
                tile.marked = false
                tile.setImage(nil, forState: .Normal)
                flagsLeft += 1
                updateFlagCounter()
            }
            else if tile.flipped == false {
                tile.flipped = true
                tile.marked = false
                tile.setBackgroundImage(nil, forState: .Normal)
                
                if tile.isBomb {
                    tile.layer.backgroundColor = UIColor.whiteColor().CGColor
                    let image1:UIImage = UIImage(named: "landmine")!
                    let image2:UIImage = UIImage(named: "explosion")!
                    tile.setImage(image1, forState: UIControlState.Normal)
                    let size = tile.frame.width
                    tile.imageEdgeInsets = UIEdgeInsets(top: size/8, left: size/8, bottom: size/8, right: size/8)
                    tile.imageView!.animationImages = [image1, image2]
                    tile.imageView!.animationDuration = 1.0
                    tile.imageView!.animationRepeatCount = 0
                    tile.imageView!.startAnimating()
                    game.loseGame(tile)
                }
                else {
                    // Make flipped tile color lighter in day, darker in night
                    if Style.foundationColor == UIColor.blackColor(){
                        tile.layer.backgroundColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1).CGColor
                    }else{
                        tile.layer.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).CGColor
                    }
                    tile.setImage(nil, forState: .Normal)
                    game.checkWinGame()
                    if (tile.number == 0) {
                        game.clearOut(tile)
                    }
                    else {
                        tile.setTitle("\(tile.number)", forState: .Normal)
                        switch tile.number {
                        case 1: tile.setTitleColor(UIColor.cyanColor(), forState: .Normal)
                        case 2: tile.setTitleColor(UIColor.purpleColor(), forState: .Normal)
                        case 3: tile.setTitleColor(UIColor.yellowColor(), forState: .Normal)
                        case 4: tile.setTitleColor(UIColor.magentaColor(), forState: .Normal)
                        case 5: tile.setTitleColor(UIColor.greenColor(), forState: .Normal)
                        case 6: tile.setTitleColor(UIColor.blueColor(), forState: .Normal)
                        case 7: tile.setTitleColor(UIColor.redColor(), forState: .Normal)
                        default: tile.setTitleColor(UIColor.blackColor(), forState: .Normal)
                        }
                    }
                }
            }
            if game.loseOrWin == 1{
                updateData("")
                playAgainNotification("GAME OVER", msg: "Better luck next time!")
            }else if game.loseOrWin == 2{
                updateData("")
                playAgainNotification("You won!", msg: "Great job :)")
            }
        }
    }
    
    // Place a flag when tile is longPressed
    @IBAction func tileLongPressed(sender: UILongPressGestureRecognizer) {
        if game.pauseGame == 0{
            let tile = sender.view as! Tile
            if tile.flipped == false && !tile.marked{
                tile.marked = true
                let image = UIImage(named: "flag")
                let size = tile.frame.width
                tile.setImage(image, forState: .Normal)
                tile.imageEdgeInsets = UIEdgeInsets(top: size/6, left: size/5, bottom: size/6, right: size/6)
                tile.imageView?.layer.shadowColor = UIColor.blackColor().CGColor
                tile.imageView?.layer.shadowOffset = CGSizeMake(1, 1)
                tile.imageView?.layer.shadowOpacity = 0.7
                tile.imageView?.layer.shadowRadius = 1
                flagsLeft -= 1
                updateFlagCounter()
            }
        }
    }
    
    // Display the correct counter for flags
    func updateFlagCounter(){
        self.flagNumber.text = "\(flagsLeft)"
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
