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
    
//    override func viewWillAppear(animated: Bool) {
//        e8.text = "Easy: \(boardArray[0].times[0] / 60) min, \(boardArray[0].times[0] % 60) sec"
//        e10.text = "Easy: \(boardArray[1].times[0] / 60) min, \(boardArray[1].times[0] % 60) sec"
//        e12.text = "Easy: \(boardArray[2].times[0] / 60) min, \(boardArray[2].times[0] % 60) sec"
//        m8.text = "Medium: \(boardArray[0].times[1] / 60) min, \(boardArray[0].times[1] % 60) sec"
//        m10.text = "Medium: \(boardArray[1].times[1] / 60) min, \(boardArray[1].times[1] % 60) sec"
//        m12.text = "Medium: \(boardArray[2].times[1] / 60) min, \(boardArray[2].times[1] % 60) sec"
//        h8.text = "Hard: \(boardArray[0].times[2] / 60) min, \(boardArray[0].times[2] % 60) sec"
//        h10.text = "Hard: \(boardArray[1].times[2] / 60) min, \(boardArray[1].times[2] % 60) sec"
//        h12.text = "Hard: \(boardArray[2].times[2] / 60) min, \(boardArray[2].times[2] % 60) sec"
//    }
    
    
    override func viewWillAppear(animated: Bool) {
        displayScores()
    }
    
    func displayScores() {
        e8.text = "Easy: \((NSUserDefaults.standardUserDefaults().valueForKey("8Easy") as! Int) / 60) min, \((NSUserDefaults.standardUserDefaults().valueForKey("8Easy") as! Int) % 60) sec"
        e10.text = "Easy: \((NSUserDefaults.standardUserDefaults().valueForKey("10Easy") as! Int)) min, \((NSUserDefaults.standardUserDefaults().valueForKey("10Easy") as! Int) % 60) sec"
        e12.text = "Easy: \((NSUserDefaults.standardUserDefaults().valueForKey("12Easy") as! Int) / 60) min, \((NSUserDefaults.standardUserDefaults().valueForKey("12Easy") as! Int) % 60) sec"
        m8.text = "Medium: \((NSUserDefaults.standardUserDefaults().valueForKey("8Medium") as! Int)) min, \((NSUserDefaults.standardUserDefaults().valueForKey("8Medium") as! Int) % 60) sec"
        m10.text = "Medium: \((NSUserDefaults.standardUserDefaults().valueForKey("10Medium") as! Int)) min, \((NSUserDefaults.standardUserDefaults().valueForKey("10Medium") as! Int)) sec"
        m12.text = "Medium: \((NSUserDefaults.standardUserDefaults().valueForKey("12Medium") as! Int) / 60) min, \((NSUserDefaults.standardUserDefaults().valueForKey("12Medium") as! Int) % 60) sec"
        h8.text = "Hard: \((NSUserDefaults.standardUserDefaults().valueForKey("8Hard") as! Int)) min, \((NSUserDefaults.standardUserDefaults().valueForKey("8Hard") as! Int) % 60) sec"
        h10.text = "Hard: \((NSUserDefaults.standardUserDefaults().valueForKey("10Hard") as! Int)) min, \((NSUserDefaults.standardUserDefaults().valueForKey("10Hard") as! Int) % 60) sec"
        h12.text = "Hard: \((NSUserDefaults.standardUserDefaults().valueForKey("12Hard") as! Int) / 60) min, \((NSUserDefaults.standardUserDefaults().valueForKey("12Hard") as! Int) % 60) sec"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}