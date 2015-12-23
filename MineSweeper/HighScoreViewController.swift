//
//  HighScoreViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/3/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    @IBOutlet weak var e8: UILabel!
    @IBOutlet weak var m8: UILabel!
    @IBOutlet weak var h8: UILabel!
    @IBOutlet weak var e10: UILabel!
    @IBOutlet weak var m10: UILabel!
    @IBOutlet weak var h10: UILabel!
    @IBOutlet weak var e12: UILabel!
    @IBOutlet weak var m12: UILabel!
    @IBOutlet weak var h12: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        e8.hidden = true
        e10.hidden = true
        e12.hidden = true
        m8.hidden = true
        m10.hidden = true
        m12.hidden = true
        h8.hidden = true
        h10.hidden = true
        h12.hidden = true
        
        displayScores()
    }
    
    func displayScores() {
        let scores = scoreToText()
        e8.text = "Easy: " + scores[0]
        e10.text = "Easy: " + scores[1]
        e12.text = "Easy: " + scores[2]
        m8.text = "Medium: " + scores[3]
        m10.text = "Medium: " + scores[4]
        m12.text = "Medium: " + scores[5]
        h8.text = "Hard: " + scores[6]
        h10.text = "Hard: " + scores[7]
        h12.text = "Hard: " + scores[8]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToRoot(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clearHighScores(sender: UIButton) {
        let kArray = ["8Easy", "10Easy", "12Easy", "8Medium", "10Medium", "12Medium", "8Hard", "10Hard", "12Hard"]
        for key in kArray {
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        displayScores()
    }
    
    @IBAction func showEightBoard(sender: UIButton) {
        if e8.hidden == false{
            e8.hidden = true
            m8.hidden = true
            h8.hidden = true
        }else{
            e8.hidden = false
            m8.hidden = false
            h8.hidden = false
        }
    }
    
    @IBAction func showTenBoard(sender: UIButton) {
        if e10.hidden == false{
            e10.hidden = true
            m10.hidden = true
            h10.hidden = true
        }else{
            e10.hidden = false
            m10.hidden = false
            h10.hidden = false
        }
    }

    @IBAction func showTwelveBoard(sender: UIButton) {
        if e12.hidden == false{
            e12.hidden = true
            m12.hidden = true
            h12.hidden = true
        }else{
            e12.hidden = false
            m12.hidden = false
            h12.hidden = false
        }
    }
    
}
