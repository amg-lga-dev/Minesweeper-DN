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
        e8.text = "Easy: \(boardArray[0].times[0] / 60):\(boardArray[0].times[0] % 60)"
        e10.text = "Easy: \(boardArray[0].times[1] / 60):\(boardArray[0].times[1] % 60)"
        e12.text = "Easy: \(boardArray[0].times[2] / 60):\(boardArray[0].times[2] % 60)"
        m8.text = "Medium: \(boardArray[1].times[0] / 60):\(boardArray[1].times[0] % 60)"
        m10.text = "Medium: \(boardArray[1].times[1] / 60):\(boardArray[1].times[1] % 60)"
        m12.text = "Medium: \(boardArray[1].times[2] / 60):\(boardArray[1].times[2] % 60)"
        h8.text = "Hard: \(boardArray[2].times[0] / 60):\(boardArray[2].times[0] % 60)"
        h10.text = "Hard: \(boardArray[2].times[1] / 60):\(boardArray[2].times[1] % 60)"
        h12.text = "Hard: \(boardArray[2].times[2] / 60):\(boardArray[2].times[2] % 60)"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToRoot(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
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
