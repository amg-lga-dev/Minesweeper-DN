//
//  GameViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/2/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var game: MineSweeperGame!
    var gameSize: Int!
    var gameLevel: Int!
    var screenCover: UIView!
    var flagsLeft: Int = 100
    var flagNumber: UILabel!
    var timer: NSTimer!
    var time: Int = 0
    var timeLabel: UILabel!
    var bestTimeLabel: UILabel!
    var endLabel: UILabel!

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blackColor()
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        game = MineSweeperGame(gameSize: gameSize, gameLevel: gameLevel, vc: self)
        flagsLeft = gameSize * gameSize
        for tile in game.tiles {
            tile.addTarget(self, action: "tilePressed:", forControlEvents: .TouchUpInside)
            let longPress = UILongPressGestureRecognizer(target: self, action: "tileLongPressed:")
            longPress.minimumPressDuration = 1
            tile.addGestureRecognizer(longPress)
        }
        
        let alertController = UIAlertController(title: "Ready to Sweep?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Mine!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // action to happen when okay is selected
            self.game.initTimer()
        }))
        
        alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
        presentViewController(alertController, animated: true, completion: nil)
        
        self.screenCover = UIView(frame: CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.width))
        self.screenCover.backgroundColor = UIColor.whiteColor()
        self.screenCover.hidden = true
        let w = self.screenCover.bounds.width
        let mine = UIImageView(frame: CGRect(x: w/4, y: 65, width: w/2, height: w/2))
        mine.image = UIImage(named: "landmine")
        let caption = UILabel(frame: CGRect(x: 5, y: w-45, width: w-10, height: 30))
        caption.text = "Take a breather..."
        caption.font = UIFont(name: "Gill Sans", size: 24)
        caption.textColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
        caption.textAlignment = .Center
        self.screenCover.addSubview(mine)
        self.screenCover.addSubview(caption)
        self.view.addSubview(self.screenCover)
        
        let flagImage = UIImageView(frame: CGRect(x: 10, y: self.view.bounds.height - 35, width: 25, height: 25))
        flagImage.image = UIImage(named: "flag")
        flagNumber = UILabel(frame: CGRect(x: 40, y: self.view.bounds.height - 35, width: 50, height: 30))
        flagNumber.font = UIFont(name: "Gill Sans", size: 18)
        flagNumber.textColor = UIColor.whiteColor()
        updateFlagCounter()
        
        view.addSubview(flagImage)
        view.addSubview(flagNumber)
    }
    
    override func viewWillAppear(animated: Bool) {
        time = 0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " Quit", style: .Plain, target: self, action: "quit:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .Plain, target: self, action: "pauseButtonPressed:")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1)
    }
    
    // Called when the quit nav bar item is pressed
    func quit(sender: AnyObject){
        if game.loseOrWin != 0{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            game.pauseGame = 1
            let alertController = UIAlertController(title: "Are you sure you want to quit?", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Quit", style: .Destructive, handler: { (action) -> Void in
                // What happens when quit is pressed in the alert
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
                // Do nothing if cancel is pressed in alert
                self.game.pauseGame = 0
            }))
            alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Called when pause button is pressed
    func pauseButtonPressed(sender: AnyObject){
        if game.loseOrWin == 0{
            if self.navigationItem.rightBarButtonItem?.title == "Pause"{
                game.pauseGame = 1
                self.navigationItem.rightBarButtonItem?.title = "Resume"
                screenCover.hidden = false
            }else{
                game.pauseGame = 0
                self.navigationItem.rightBarButtonItem?.title = "Pause"
                screenCover.hidden = true
            }
        }
    }
    
    // Reset tiles to "nil" initial state
    func resetTiles(){
        for tile in game.tiles{
            tile.number = -2
            tile.isBomb = false
            tile.flipped = false
            tile.marked = false
            tile.backgroundColor = UIColor.blackColor()
            tile.layer.borderColor = UIColor.whiteColor().CGColor
            tile.layer.borderWidth = 1.0
        }
    }
    
    // Recreate game, reset timer and flags.
    func recreateGame(){
        self.time = 0
        self.timeLabel.removeFromSuperview()
        self.bestTimeLabel.removeFromSuperview()
        self.endLabel.removeFromSuperview()
        self.game = MineSweeperGame(gameSize: gameSize, gameLevel: gameLevel, vc: self)
        self.flagsLeft = gameSize * gameSize
        self.view.bringSubviewToFront(screenCover)
        updateFlagCounter()
        for tile in game.tiles {
            tile.addTarget(self, action: "tilePressed:", forControlEvents: .TouchUpInside)
            let longPress = UILongPressGestureRecognizer(target: self, action: "tileLongPressed:")
            longPress.minimumPressDuration = 1
            tile.addGestureRecognizer(longPress)
        }
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
        game.setBombs()
        game.setNumbers()
        if tile.isBomb{
            print("Tile Number: \(tile.number)")
            resetBoard(tile)
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
                flagsLeft++
                updateFlagCounter()
            }
            else if tile.flipped == false {
                tile.flipped = true
                tile.marked = false
                
                if tile.isBomb {
                    tile.layer.backgroundColor = UIColor.whiteColor().CGColor
                    let image1:UIImage = UIImage(named: "landmine")!
                    let image2:UIImage = UIImage(named: "explosion")!
                    tile.setImage(image1, forState: UIControlState.Normal)
                    tile.imageView!.animationImages = [image1, image2]
                    tile.imageView!.animationDuration = 1.0
                    tile.imageView!.animationRepeatCount = 0
                    tile.imageView!.startAnimating()
                    game.loseGame(tile)
                }
                else {
                    tile.layer.backgroundColor = UIColor.grayColor().CGColor
                    tile.setImage(nil, forState: .Normal)
                    game.checkWinGame()
                    if (tile.number == 0) {
                        game.clearOut(tile)
                    }
                    else {
                        tile.setTitle("\(tile.number)", forState: .Normal)
                        switch tile.number {
                        case 1: tile.setTitleColor(UIColor.greenColor(), forState: .Normal)
                        case 2: tile.setTitleColor(UIColor.blueColor(), forState: .Normal)
                        case 3: tile.setTitleColor(UIColor.yellowColor(), forState: .Normal)
                        case 4: tile.setTitleColor(UIColor.magentaColor(), forState: .Normal)
                        default: tile.setTitleColor(UIColor.redColor(), forState: .Normal)
                        }
                    }
                }
            }
            if game.loseOrWin == 1{
                playAgainNotification("GAME OVER", msg: "Better luck next time!")
            }else if game.loseOrWin == 2{
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
                tile.setImage(image, forState: .Normal)
                flagsLeft--
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
