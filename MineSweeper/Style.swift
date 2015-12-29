//
//  Style.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/29/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    static var themes = ["Day", "Night"]
    static var foundationColor = UIColor.blackColor()
    static var textColor = UIColor.whiteColor()
    
    static func changeTheme() {
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if theme == "Day" { setDayTheme() }
        if theme == "Night" { setNightTheme() }
    }
    
    static func setNightTheme() {
        foundationColor = UIColor.blackColor()
        textColor = UIColor.whiteColor()
    }
    
    static func setDayTheme() {
        foundationColor = UIColor.whiteColor()
        textColor = UIColor.blackColor()
    }
    
}

