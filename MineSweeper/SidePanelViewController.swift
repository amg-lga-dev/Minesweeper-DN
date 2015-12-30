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
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if theme == "Day"{
            themeSeg.selectedSegmentIndex = 0
            setToDay()
        }else{
            themeSeg.selectedSegmentIndex = 1
            setToNight()
        }
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
    }
    
    @IBAction func themeSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            NSUserDefaults.standardUserDefaults().setValue("Day", forKey: "theme")
            setToDay()
        }else{
            NSUserDefaults.standardUserDefaults().setValue("Night", forKey: "theme")
            setToNight()
        }
        Style.changeTheme()
        introVC?.viewWillAppear(true)
    }
    
    func setToDay(){
        backgroundImage.image = UIImage(named: "sky")
        bottomImage.layer.opacity = 1
        themeLabel.textColor = UIColor.blackColor()
        boardLabel.textColor = UIColor.blackColor()
        levelLabel.textColor = UIColor.blackColor()
        //themeSeg.tintColor = UIColor.blackColor()
        //boardSeg.tintColor = UIColor.blackColor()
        //levelSeg.tintColor = UIColor.blackColor()
    }
    
    func setToNight(){
        backgroundImage.image = UIImage(named: "nightSky")
        bottomImage.layer.opacity = 0.7
        themeLabel.textColor = UIColor.whiteColor()
        boardLabel.textColor = UIColor.whiteColor()
        levelLabel.textColor = UIColor.whiteColor()
        themeSeg.tintColor = UIColor.whiteColor()
        boardSeg.tintColor = UIColor.whiteColor()
        levelSeg.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func boardSegment(sender: UISegmentedControl) {
        introVC?.gameType = sender.selectedSegmentIndex
    }
    @IBAction func levelSegment(sender: UISegmentedControl) {
        introVC?.gameLevel = sender.selectedSegmentIndex
    }

}
