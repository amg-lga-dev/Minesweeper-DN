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
    var timer: NSTimer!
    var time: Int
    var timeLabel: UILabel!
    var bestTimeLabel: UILabel!
    var gameLevel: Int
    var pauseGame: Int
    var loseOrWin: Int
    var firstTilePressed: Int
    
    init(gameSize: Int, gameLevel: Int, vc: GameViewController) {
        self.gameLevel = gameLevel
        self.gvc = vc
        self.gameSize = gameSize
        self.time = 0
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
        
        bestTimeLabel = UILabel(frame: CGRect(x: 10.0, y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 3), height: 30.0))
        let bestTime = boardArray[(gameSize - 8) / 2].times[gameLevel]
        if (bestTime % 60 < 10) {
            bestTimeLabel.text = "Best Time: \(bestTime / 60):0\(bestTime % 60)"
        }
        else {
            bestTimeLabel.text = "Best Time: \(bestTime / 60):\(bestTime % 60)"
        }
        gvc.view.addSubview(bestTimeLabel)
        
        timeLabel = UILabel(frame: CGRect(x: Double(gvc.view.bounds.width / 2), y: Double(gvc.view.bounds.width) + 80, width: Double(gvc.view.bounds.width / 2) - 10.0, height: 30.0))
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.text = "Time: 0:00"
        gvc.view.addSubview(timeLabel)
        
        setBombs()
        setNumbers()
    }
    
    func initTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    func timerFired(sender: NSTimer) {
        if pauseGame == 0{
            time++
            let seconds = time % 60
            let minutes = time / 60
            if seconds < 10 {
                timeLabel.text = "Time: \(minutes):0\(seconds)"
            }
            else {
                timeLabel.text = "Time: \(minutes):\(seconds)"
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
    
    func loseGame() {
        for tile in tiles {
            tile.enabled = false
            if tile.isBomb {
                tile.layer.backgroundColor = UIColor.whiteColor().CGColor
                tile.setImage(UIImage(named: "bomb"), forState: .Normal)
            }
        }
        
        timer.invalidate()
        
        let endLabel = UILabel(frame: CGRect(x: 0, y: gvc.view.bounds.height - 60, width: gvc.view.bounds.width, height: 30))
        endLabel.text = "Game Over"
        endLabel.textColor = UIColor.redColor()
        endLabel.textAlignment = NSTextAlignment.Center
        endLabel.font = UIFont.systemFontOfSize(40, weight: 1)
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
            timer.invalidate()
            let endLabel = UILabel(frame: CGRect(x: 0, y: gvc.view.bounds.height - 60, width: gvc.view.bounds.width, height: 30))
            endLabel.text = "You Win"
            endLabel.textColor = UIColor.greenColor()
            endLabel.textAlignment = NSTextAlignment.Center
            endLabel.font = UIFont.systemFontOfSize(40, weight: 1)
            gvc.view.addSubview(endLabel)
            boardArray[(gameSize - 8) / 2].updateScore(gameLevel, time: time)
            loseOrWin = 1
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
