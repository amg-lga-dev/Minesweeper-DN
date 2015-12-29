//
//  MineSweeperGame.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/2/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class MineSweeperGame: NSObject {
    var gameSize: Int!
    var tiles: [Tile]
    var gvc: GameViewController
    //var timer: NSTimer!
    //var time: Int
    //var timeLabel: UILabel!
    //var bestTimeLabel: UILabel!
    var gameLevel: Int
    var pauseGame: Int
    var loseOrWin: Int
    var firstTilePressed: Int
    
    init(gameSize: Int, gameLevel: Int, vc: GameViewController) {
        self.gameLevel = gameLevel
        self.gvc = vc
        self.gameSize = gameSize
        self.pauseGame = 0
        self.loseOrWin = 0
        self.firstTilePressed = 0
        tiles = []
        super.init()
        setTilesInView()
    }
    
    
    func setTilesInView() {
        let tileSide = Double(gvc.view.bounds.width) / Double(gameSize)
        var counter = 0
        
        for row in 0...(gameSize - 1) {
            for column in 0...(gameSize - 1) {
                let newTile = Tile(frame: CGRect(x: tileSide * Double(column), y: 65 + tileSide * Double(row), width: tileSide, height: tileSide))
                newTile.tag = counter
                counter++
                tiles.append(newTile)
                gvc.view.addSubview(newTile)
            }
        }
        
        gvc.bestTimeLabel = UILabel(frame: CGRect(x: 10.0, y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 3), height: 30.0))
        gvc.bestTimeLabel.font = UIFont(name: "Gill Sans", size: 18)
        var bestTime = 0
        switch gameLevel {
        case 0: bestTime = NSUserDefaults.standardUserDefaults().valueForKey("\(gameSize)Easy") as! Int
        case 1: bestTime = NSUserDefaults.standardUserDefaults().valueForKey("\(gameSize)Medium") as! Int
        case 2: bestTime = NSUserDefaults.standardUserDefaults().valueForKey("\(gameSize)Hard") as! Int
        default: bestTime = 0
        }
        if (bestTime == 0) {
            gvc.bestTimeLabel.text = "Best Time: n/A"
        }
        else {
            if (bestTime % 60 < 10) {
                gvc.bestTimeLabel.text = "Best Time: \(bestTime / 60):0\(bestTime % 60)"
            }
            else {
                gvc.bestTimeLabel.text = "Best Time: \(bestTime / 60):\(bestTime % 60)"
            }
        }
        gvc.view.addSubview(gvc.bestTimeLabel)
        
        gvc.timeLabel = UILabel(frame: CGRect(x: Double(gvc.view.bounds.width / 2), y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 2) - 10.0, height: 30.0))
        gvc.timeLabel.font = UIFont(name: "Gill Sans", size: 18)
        gvc.timeLabel.textAlignment = NSTextAlignment.Right
        gvc.timeLabel.text = "Time: 0:00"
        gvc.view.addSubview(gvc.timeLabel)
        
        setBombs()
        setNumbers()
    }
    
    func initTimer() {
        gvc.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    func timerFired(sender: NSTimer) {
        if pauseGame == 0{
            gvc.time++
            let seconds = gvc.time % 60
            let minutes = gvc.time / 60
            if seconds < 10 {
                gvc.timeLabel.text = "Time: \(minutes):0\(seconds)"
            }
            else {
                gvc.timeLabel.text = "Time: \(minutes):\(seconds)"
            }
        }
    }
    
    func loseGame(tilePressed: Tile) {
        for tile in tiles {
            tile.enabled = false
            if tile.isBomb && tile != tilePressed{
                tile.layer.backgroundColor = UIColor.blackColor().CGColor
                tile.setImage(UIImage(named: "landmine"), forState: .Normal)
            }
        }
        
        gvc.timer.invalidate()
        let spot = gvc.timeLabel.center.y + (gvc.view.bounds.height - gvc.timeLabel.center.y)/3
        let endLabel = UILabel(frame: CGRect(x: 0, y: spot, width: gvc.view.bounds.width, height: 50))
        endLabel.text = "Game Over"
        endLabel.font = UIFont(name: "Gill Sans", size: 50)
        endLabel.textColor = UIColor.redColor()
        endLabel.textAlignment = NSTextAlignment.Center
        gvc.view.addSubview(endLabel)
        loseOrWin = 1
    }
    
    func checkWinGame() {
        var win = true
        for tile in tiles {
            if tile.isBomb == false && tile.flipped == true {
                win = win && true
            }
            else if tile.isBomb == false && tile.flipped == false {
                win = win && false
            }
        }
        
        if win {
            for tile in tiles {
                tile.enabled = false
            }
            gvc.timer.invalidate()
            let spot = gvc.timeLabel.center.y + (gvc.view.bounds.height - gvc.timeLabel.center.y)/3
            let endLabel = UILabel(frame: CGRect(x: 0, y: spot, width: gvc.view.bounds.width, height: 50))
            endLabel.text = "You Win"
            endLabel.font = UIFont(name: "Gill Sans", size: 50)
            endLabel.textColor = UIColor.greenColor()
            endLabel.textAlignment = NSTextAlignment.Center
            gvc.view.addSubview(endLabel)
            var key = ""
            switch self.gameLevel {
            case 0: key = "\(gameSize)Easy"
            case 1: key = "\(gameSize)Medium"
            case 2: key = "\(gameSize)Hard"
            default: key = "error"
            }
            if ((NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int) > gvc.time || (NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int) == 0) {
                NSUserDefaults.standardUserDefaults().setValue(gvc.time, forKey: key)
            }
            loseOrWin = 1
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func clearOut(tile: Tile) {
        let index = tiles.indexOf(tile)!
        
        if (index % gameSize == 0) { //tile is on far left
            gvc.tilePressed(tiles[index + 1]) // press right tile
            
            if (index - gameSize >= 0) { //press top and top right if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index + 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) { //press bot and bot right if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index + 1 + gameSize])
            }
        }
        else if (index % gameSize == gameSize - 1) {  //tile is on far right
            gvc.tilePressed(tiles[index - 1])   // press left
            
            if (index - gameSize >= 0) { //press top and top left if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index - 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) { //press bot and bot left if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index - 1 + gameSize])
            }
            
        }
        else {  //tile is somewhere in the middle
            gvc.tilePressed(tiles[index - 1])   //press left
            gvc.tilePressed(tiles[index + 1])   //press right
            
            if (index - gameSize >= 0) { //press top, top right, and top left if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index + 1 - gameSize])
                gvc.tilePressed(tiles[index - 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) { //press bot, bot right, and bot left if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index + 1 + gameSize])
                gvc.tilePressed(tiles[index - 1 + gameSize])
            }
        }
    }
    
    
    func setBombs() {
        for tile in tiles {
            let y = UInt32(5 - gameLevel)
            let x = Int(arc4random_uniform(y)) + 1  // makes more bombs if level is higher
            if (x == 1) {
                tile.isBomb = true
            }
        }
    }
    
    func setNumbers() {
        for tile in tiles {
            if tile.isBomb {
                tile.number = -1
            }
            else {
                var counter = 0
                let index = tiles.indexOf(tile)!
                
                if (index % gameSize == 0) { //tile is on far left
                    if (tiles[index + 1].isBomb) { counter++ } // check right
                    
                    if (index - gameSize >= 0) { //check top and top right if not in top row
                        if (tiles[index - gameSize].isBomb) { counter++ }
                        if (tiles[index + 1 - gameSize].isBomb) { counter++ }
                    }
                    if (index + gameSize < (gameSize * gameSize)) { //check bot and bot right if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter++ }
                        if (tiles[index + 1 + gameSize].isBomb) { counter++ }
                    }
                }
                else if (index % gameSize == gameSize - 1) {  //tile is on far right
                    if (tiles[index - 1].isBomb) { counter++ } // check left
                    
                    if (index - gameSize >= 0) { //check top and top left if not in top row
                        if (tiles[index - gameSize].isBomb) { counter++ }
                        if (tiles[index - 1 - gameSize].isBomb) { counter++ }
                    }
                    if (index + gameSize < (gameSize * gameSize)) { //check bot and bot left if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter++ }
                        if (tiles[index - 1 + gameSize].isBomb) { counter++ }
                    }
                    
                }
                else {  //tile is somewhere in the middle
                    if (tiles[index + 1].isBomb) { counter++ } // check right
                    if (tiles[index - 1].isBomb) { counter++ } // check left
                    
                    if (index - gameSize >= 0) { //check top, top right, and top left if not in top row
                        if (tiles[index - gameSize].isBomb) { counter++ }
                        if (tiles[index + 1 - gameSize].isBomb) { counter++ }
                        if (tiles[index - 1 - gameSize].isBomb) { counter++ }
                    }
                    if (index + gameSize < (gameSize * gameSize)) { //check bot, bot right, and bot left if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter++ }
                        if (tiles[index + 1 + gameSize].isBomb) { counter++ }
                        if (tiles[index - 1 + gameSize].isBomb) { counter++ }
                    }
                }
                
                tile.number = counter
            }
        }
    }

}
