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

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.grayColor()
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        game = MineSweeperGame(gameSize: gameSize, gameLevel: gameLevel, vc: self)
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
            self.screenCover = UIView(frame: CGRect(x: 0, y: 65, width: self.view.bounds.width, height: self.view.bounds.width))
            self.screenCover.backgroundColor = UIColor.blackColor()
            self.screenCover.hidden = true
            let w = self.screenCover.bounds.width
            let mine = UIImageView(frame: CGRect(x: w/4, y: 65, width: w/2, height: w/2))
            mine.image = UIImage(named: "landmine")
            self.screenCover.addSubview(mine)
            self.view.addSubview(self.screenCover)
        }))
        
        alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " Quit", style: .Plain, target: self, action: "quit:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .Plain, target: self, action: "pauseButtonPressed:")
    }
    
    func quit(sender: AnyObject){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
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
        }
    }
    
    @IBAction func tileLongPressed(sender: UILongPressGestureRecognizer) {
        if game.pauseGame == 0{
            let tile = sender.view as! Tile
            if tile.flipped == false && !tile.marked{
                tile.marked = true
                let image = UIImage(named: "flag")
                tile.setImage(image, forState: .Normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
