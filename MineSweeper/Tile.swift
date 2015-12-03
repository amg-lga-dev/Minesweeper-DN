//
//  Tile.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/2/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
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
        self.backgroundColor = UIColor.blackColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
