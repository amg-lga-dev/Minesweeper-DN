//
//  SidePanelViewController.swift
//  MineSweeper
//
//  Created by Logan Allen on 12/29/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    var introVC: IntroViewController?

    @IBOutlet weak var themeSeg: UISegmentedControl!
    @IBOutlet weak var boardSeg: UISegmentedControl!
    @IBOutlet weak var levelSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if theme == "Day"{
            themeSeg.selectedSegmentIndex = 0
        }else{
            themeSeg.selectedSegmentIndex = 1
        }
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
    }
    
    @IBAction func themeSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            NSUserDefaults.standardUserDefaults().setValue("Day", forKey: "theme")
        }else{
            NSUserDefaults.standardUserDefaults().setValue("Night", forKey: "theme")
        }
        Style.changeTheme()
        introVC?.viewWillAppear(true)
    }
    @IBAction func boardSegment(sender: UISegmentedControl) {
        introVC?.gameType = sender.selectedSegmentIndex
    }
    @IBAction func levelSegment(sender: UISegmentedControl) {
        introVC?.gameLevel = sender.selectedSegmentIndex
    }

}
