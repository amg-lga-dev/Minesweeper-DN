//
//  MineSweeperGame.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/2/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

class MineSweeperGame: NSObject {
    var gameSize: Int!
    var tiles: [Tile]
    var gvc: GameViewController
    var gameLevel: Int
    var pauseGame: Int
    var loseOrWin: Int
    var firstTilePressed: Int
    var numMines: Int
    let mineRanges: [Double] = [0.16, 0.2, 0.24, 0.28]
    
    // Constructor
    init(gameSize: Int, gameLevel: Int, vc: GameViewController) {
        self.gameLevel = gameLevel
        self.gvc = vc
        self.gameSize = gameSize
        self.pauseGame = 0
        self.loseOrWin = 0
        self.firstTilePressed = 0
        self.numMines = 0
        tiles = []
        super.init()
        setTilesInView()
    }
    
    // Draw tiles and time lables in the gameVC
    func setTilesInView() {
        let tileSide = Double(gvc.boardView.bounds.width) / Double(gameSize)
        var counter = 0
        
        // Draw tiles
        for row in 0...(gameSize - 1) {
            for column in 0...(gameSize - 1) {
                let newTile = Tile(frame: CGRect(x: tileSide * Double(column), y: tileSide * Double(row), width: tileSide, height: tileSide))
                newTile.tag = counter
                counter += 1
                tiles.append(newTile)
                gvc.boardView.addSubview(newTile)
            }
        }
        
        // Create best time label
        gvc.bestTimeLabel = UILabel(frame: CGRect(x: 10.0, y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 2), height: 30.0))
        gvc.bestTimeLabel.font = UIFont(name: "Gill Sans", size: 18)
        gvc.bestTimeLabel.textColor = Style.textColor
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
        
        // Create current timer label
        gvc.timeLabel = UILabel(frame: CGRect(x: Double(gvc.view.bounds.width / 2), y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 2) - 10.0, height: 30.0))
        gvc.timeLabel.font = UIFont(name: "Gill Sans", size: 18)
        gvc.timeLabel.textAlignment = NSTextAlignment.Right
        gvc.timeLabel.text = "Time: 0:00"
        gvc.timeLabel.textColor = Style.textColor
        gvc.view.addSubview(gvc.timeLabel)
        
        // Call functions to place bombs and numbers in tiles
        setBombs()
        setNumbers()
    }
    
    // Initiate the current timer
    func initTimer() {
        gvc.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MineSweeperGame.timerFired(_:)), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(gvc.timer, forMode: NSRunLoopCommonModes)
    }
    
    // Increase timer every second
    func timerFired(sender: NSTimer) {
        if pauseGame == 0{
            gvc.time += 1
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
    
    // Display hidden bombs on the game board and display "Game Over" label
    func loseGame(tilePressed: Tile) {
        for tile in tiles {
            //tile.enabled = false
            if tile.isBomb && tile != tilePressed{
                tile.layer.backgroundColor = UIColor.blackColor().CGColor
                tile.setBackgroundImage(nil, forState: .Normal)
                tile.setImage(UIImage(named: "landmine"), forState: .Normal)
                let size = tile.frame.width
                tile.imageEdgeInsets = UIEdgeInsets(top: size/8, left: size/8, bottom: size/8, right: size/8)
            }
        }
        
        gvc.timer.invalidate()
        loseOrWin = 1
    }
    
    // Checks if all non-mine tiles are flipped and displays "You Win" label if so
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
            var key = ""
            switch self.gameLevel {
            case 0: key = "\(gameSize)Easy"
            case 1: key = "\(gameSize)Medium"
            case 2: key = "\(gameSize)Hard"
            default: key = "error"
            }
            
            // Update best time if applicable
            if ((NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int) > gvc.time || (NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int) == 0) {
                NSUserDefaults.standardUserDefaults().setValue(gvc.time, forKey: key)
            }
            loseOrWin = 2
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // Function clearing out adjacent tiles if the tile pressed was blank
    func clearOut(tile: Tile) {
        let index = tiles.indexOf(tile)!
        
        if (index % gameSize == 0) {
            // tile is on far left
            gvc.tilePressed(tiles[index + 1])
            // press right tile
            
            if (index - gameSize >= 0) {
                // press top and top right if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index + 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) {
                // press bot and bot right if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index + 1 + gameSize])
            }
        }
        else if (index % gameSize == gameSize - 1) {
            // tile is on far right
            gvc.tilePressed(tiles[index - 1])
            // press left
            
            if (index - gameSize >= 0) {
                // press top and top left if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index - 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) {
                // press bot and bot left if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index - 1 + gameSize])
            }
            
        }
        else {
            // tile is somewhere in the middle
            gvc.tilePressed(tiles[index - 1])   //press left
            gvc.tilePressed(tiles[index + 1])   //press right
            
            if (index - gameSize >= 0) {
                // press top, top right, and top left if not in top row
                gvc.tilePressed(tiles[index - gameSize])
                gvc.tilePressed(tiles[index + 1 - gameSize])
                gvc.tilePressed(tiles[index - 1 - gameSize])
            }
            if (index + gameSize < (gameSize * gameSize)) {
                // press bot, bot right, and bot left if not in bot row
                gvc.tilePressed(tiles[index + gameSize])
                gvc.tilePressed(tiles[index + 1 + gameSize])
                gvc.tilePressed(tiles[index - 1 + gameSize])
            }
        }
    }
    
    // Checks if number of mines is within specified range
    //
    func checkNumMines() -> Bool {
        let totalTiles: Double = Double(gameSize*gameSize)
        if gameLevel == 0{
            if Double(numMines) < round(mineRanges[0]*totalTiles) || round(mineRanges[1]*totalTiles) < Double(numMines){
                return false
            }
        }else if gameLevel == 1{
            if Double(numMines) < round(mineRanges[1]*totalTiles) || round(mineRanges[2]*totalTiles) < Double(numMines){
                return false
            }
        }else{
            if Double(numMines) < round(mineRanges[2]*totalTiles) || round(mineRanges[3]*totalTiles) < Double(numMines){
                return false
            }
        }
        return true;
    }
    
    // Sets mines randomly depending on difficulty
    func setBombs() {
        for tile in tiles {
            let y = UInt32(5 - gameLevel)
            let x = Int(arc4random_uniform(y)) + 1
            // Easy: 1/6, Med: 1/5, Hard: 1/4
            if (x == 1) {
                tile.isBomb = true
                numMines += 1
            }
        }
        if checkNumMines() == false{
            for tile in tiles { tile.isBomb = false }
            numMines = 0
            setBombs()
        }
    }
    
    // Sets corresponding numbers to non-mine tiles
    func setNumbers() {
        for tile in tiles {
            if tile.isBomb {
                tile.number = -1
            }
            else {
                var counter = 0
                let index = tiles.indexOf(tile)!
                
                if (index % gameSize == 0) {
                    // tile is on far left
                    if (tiles[index + 1].isBomb) { counter += 1 }
                    // check right
                    
                    if (index - gameSize >= 0) {
                        // check top and top right if not in top row
                        if (tiles[index - gameSize].isBomb) { counter += 1 }
                        if (tiles[index + 1 - gameSize].isBomb) { counter += 1 }
                    }
                    if (index + gameSize < (gameSize * gameSize)) {
                        // check bot and bot right if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter += 1 }
                        if (tiles[index + 1 + gameSize].isBomb) { counter += 1 }
                    }
                }
                else if (index % gameSize == gameSize - 1) {
                    // tile is on far right
                    if (tiles[index - 1].isBomb) { counter += 1 }
                    // check left
                    
                    if (index - gameSize >= 0) {
                        // check top and top left if not in top row
                        if (tiles[index - gameSize].isBomb) { counter += 1 }
                        if (tiles[index - 1 - gameSize].isBomb) { counter += 1 }
                    }
                    if (index + gameSize < (gameSize * gameSize)) {
                        // check bot and bot left if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter += 1 }
                        if (tiles[index - 1 + gameSize].isBomb) { counter += 1 }
                    }
                    
                }
                else {
                    // tile is somewhere in the middle
                    if (tiles[index + 1].isBomb) { counter += 1 }
                    // check right
                    if (tiles[index - 1].isBomb) { counter += 1 }
                    // check left
                    
                    if (index - gameSize >= 0) {
                        // check top, top right, and top left if not in top row
                        if (tiles[index - gameSize].isBomb) { counter += 1 }
                        if (tiles[index + 1 - gameSize].isBomb) { counter += 1 }
                        if (tiles[index - 1 - gameSize].isBomb) { counter += 1 }
                    }
                    if (index + gameSize < (gameSize * gameSize)) {
                        // check bot, bot right, and bot left if not in bot row
                        if (tiles[index + gameSize].isBomb) { counter += 1 }
                        if (tiles[index + 1 + gameSize].isBomb) { counter += 1 }
                        if (tiles[index - 1 + gameSize].isBomb) { counter += 1 }
                    }
                }
                
                tile.number = counter
            }
        }
    }

}
