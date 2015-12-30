//
//  ScorePanelViewController.swift
//  MineSweeper
//
//  Created by Logan Allen on 12/29/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class ScorePanelViewController: UIViewController {
    
    var introVC: IntroViewController?

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var boardSeg: UISegmentedControl!
    @IBOutlet weak var levelSeg: UISegmentedControl!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
    }
    
    func setTheme(theme: String){
        if theme == "Day"{
            backgroundImage.image = UIImage(named: "sky")
            bottomImage.layer.opacity = 1
        }else{
            backgroundImage.image = UIImage(named: "nightSky")
            bottomImage.layer.opacity = 0.7
        }
        for view in self.view.subviews {
            (view as? UILabel)?.textColor = Style.textColor
            (view as? UISegmentedControl)?.tintColor = UIColor.whiteColor()
        }
    }
    
    func getData(board: Int, level: Int) -> [String]{
        let num = 8 + 2*board
        var diff: String = ""
        if level == 0{
            diff = "Easy"
        }else if level == 1{
            diff = "Medium"
        }else{
            diff = "Hard"
        }
        let key = "\(num)\(diff)"
        print(key)
        return []
    }
    
    func scoreToText() -> [String] {
        var returnArray: [String] = [];
        let easy8 = NSUserDefaults.standardUserDefaults().valueForKey("8Easy") as! Int
        let easy10 = NSUserDefaults.standardUserDefaults().valueForKey("10Easy") as! Int
        let easy12 = NSUserDefaults.standardUserDefaults().valueForKey("12Easy") as! Int
        let medium8 = NSUserDefaults.standardUserDefaults().valueForKey("8Medium") as! Int
        let medium10 = NSUserDefaults.standardUserDefaults().valueForKey("10Medium") as! Int
        let medium12 = NSUserDefaults.standardUserDefaults().valueForKey("12Medium") as! Int
        let hard8 = NSUserDefaults.standardUserDefaults().valueForKey("8Hard") as! Int
        let hard10 = NSUserDefaults.standardUserDefaults().valueForKey("10Hard") as! Int
        let hard12 = NSUserDefaults.standardUserDefaults().valueForKey("12Hard") as! Int
        let scores = [easy8, easy10, easy12, medium8, medium10, medium12, hard8, hard10, hard12]
        for score in scores {
            if (score == 0) {
                returnArray.append("n/A")
            }
            else {
                let mins = score / 60
                let secs = score % 60
                if (secs < 10) {
                    returnArray.append("\(mins):0\(secs)")
                }
                else {
                    returnArray.append("\(mins):\(secs)")
                }
            }
        }
        return returnArray
    }

}
