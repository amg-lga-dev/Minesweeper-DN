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
    
//    @IBOutlet weak var themeLabel: UILabel!
//    @IBOutlet weak var boardLabel: UILabel!
//    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
    }
    
    @IBAction func themeSegment(sender: UISegmentedControl) {
        var theme: String = ""
        if sender.selectedSegmentIndex == 0{
            NSUserDefaults.standardUserDefaults().setValue("Day", forKey: "theme")
            theme = "Day"
        }else{
            NSUserDefaults.standardUserDefaults().setValue("Night", forKey: "theme")
            theme = "Night"
        }
        Style.changeTheme()
        setTheme(theme)
        introVC?.viewWillAppear(true)
    }
    
    func setTheme(theme: String){
        if theme == "Day"{
            backgroundImage.image = UIImage(named: "sky")
            bottomImage.layer.opacity = 1
            themeSeg.selectedSegmentIndex = 0
        }else{
            backgroundImage.image = UIImage(named: "nightSky")
            bottomImage.layer.opacity = 0.7
            themeSeg.selectedSegmentIndex = 1
        }
        for view in self.view.subviews {
            (view as? UILabel)?.textColor = Style.textColor
            (view as? UISegmentedControl)?.tintColor = UIColor.whiteColor()
        }
        
    }
    
    @IBAction func boardSegment(sender: UISegmentedControl) {
        introVC?.gameType = sender.selectedSegmentIndex
    }
    @IBAction func levelSegment(sender: UISegmentedControl) {
        introVC?.gameLevel = sender.selectedSegmentIndex
    }

}
