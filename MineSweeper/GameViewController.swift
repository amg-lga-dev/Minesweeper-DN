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

    override func viewDidLoad() {
        super.viewDidLoad()
        game = MineSweeperGame(gameSize: gameSize, vc: self)
        for tile in game.tiles {
            tile.addTarget(self, action: "tilePressed:", forControlEvents: .TouchUpInside)
            let longPress = UILongPressGestureRecognizer(target: self, action: "tileLongPressed:")
            longPress.minimumPressDuration = 1
            tile.addGestureRecognizer(longPress)
        }
        
        let alertController = UIAlertController(title: "Ready to Start?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Go!", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // action to happen when okay is selected
            self.game.initTimer()
        }))
        
        alertController.view.frame = CGRect(x: 0, y: 0, width: 340, height: 450)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tilePressed(sender: UIButton) {
        let tile = sender as! Tile
        if tile.flipped == false {
            tile.flipped = true
            tile.marked = false
            
            if tile.isBomb {
                tile.layer.backgroundColor = UIColor.whiteColor().CGColor
                tile.setImage(UIImage(named: "bomb"), forState: .Normal)
                game.loseGame()
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
                }
            }
        }
    }
    
    @IBAction func tileLongPressed(sender: UILongPressGestureRecognizer) {
        let tile = sender.view as! Tile
        tile.marked = true
        tile.setImage(UIImage(named: "flag"), forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
