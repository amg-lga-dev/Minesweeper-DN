//
//  Tile.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/2/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

class Tile: UIButton {
    var flipped: Bool
    var marked: Bool
    var isBomb: Bool
    var number: Int
    
    override init(frame: CGRect) {
        self.number = -2
        self.isBomb = false
        self.flipped = false
        self.marked = false
        super.init(frame: frame)
        self.backgroundColor = Style.textColor
        self.setBackgroundImage(Style.unflippedTileImage, forState: .Normal)
        self.layer.borderColor = Style.tileBorder.CGColor
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
