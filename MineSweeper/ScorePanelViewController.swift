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
    
    @IBOutlet weak var attemptLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    var board: Int = 0
    var level: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        board = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
        level = (introVC?.gameLevel)!
        clearButton.layer.shadowOpacity = 0.7
        clearButton.layer.shadowOffset = CGSizeMake(4, 4)
        clearButton.layer.shadowRadius = 4
        clearButton.layer.shadowColor = UIColor.blackColor().CGColor
        showData()
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
            (view as? UISegmentedControl)?.layer.shadowColor = UIColor.blackColor().CGColor
            (view as? UISegmentedControl)?.layer.shadowOffset = CGSizeMake(3,3)
            (view as? UISegmentedControl)?.layer.shadowRadius = 3
            (view as? UISegmentedControl)?.layer.shadowOpacity = 0.7
        }
    }
    
    func showData(){
        let key: String = getKey()
        let time = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int
        let losses = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Fails") as! Int
        let wins = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Wins") as! Int
        let attempts = losses + wins
        
        attemptLabel.text = "\(attempts)"
        winLabel.text = "\(wins)"
        lossLabel.text = "\(losses)"
        timeLabel.text = timeToText(time)
        
    }
    
    // Get the key for NSUserDefault
    func getKey() -> String{
        let num = 8 + 2*board
        var diff: String = ""
        
        if level == 0{
            diff = "Easy"
        }else if level == 1{
            diff = "Medium"
        }else{
            diff = "Hard"
        }
        
        return "\(num)\(diff)"
    }
    
    // Convert time to minutes and seconds
    func timeToText(score: Int) -> String {
        
        var time: String = ""
        
        if (score == 0) {
            time = "unknown"
        }
        else {
            let mins = score / 60
            let secs = score % 60
            if (secs < 10) {
                time = "\(mins): 0\(secs)"
            }
            else {
                time = "\(mins): \(secs)"
            }
        }
        
        return time
    }
    
    @IBAction func boardSelected(sender: UISegmentedControl) {
        self.board = sender.selectedSegmentIndex
        showData()
    }
    @IBAction func levelSelected(sender: UISegmentedControl) {
        self.level = sender.selectedSegmentIndex
        showData()
    }
    
    // Clear data for selected board & level
    @IBAction func clearScores(sender: UIButton) {
        let key: String = getKey()
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "\(key)Fails")
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "\(key)Wins")
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: key)
        showData()
    }

}
