//
//  Style.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/29/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    static var themes = ["Day", "Night"]
    static var foundationColor = UIColor.blackColor()
    static var textColor = UIColor.whiteColor()
    static var unflippedTile = UIColor.blackColor()
    static var tileBorder = UIColor.whiteColor()
    static var navBar = UIColor.blackColor()
    
    // Change the theme of the app
    static func changeTheme() {
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if theme == "Day" { setDayTheme() }
        if theme == "Night" { setNightTheme() }
    }
    
    // Set to night theme -- black with white text
    static func setNightTheme() {
        foundationColor = UIColor.blackColor()
        textColor = UIColor.whiteColor()
        unflippedTile = UIColor.blackColor()
        tileBorder = UIColor.whiteColor()
        navBar = UIColor.blackColor()
    }
    
    // Set to day theme -- white with black text
    static func setDayTheme() {
        foundationColor = UIColor.whiteColor()
        textColor = UIColor.blackColor()
        unflippedTile = UIColor.whiteColor()
        tileBorder = UIColor.blackColor()
        navBar = UIColor.whiteColor()
    }
    
}

