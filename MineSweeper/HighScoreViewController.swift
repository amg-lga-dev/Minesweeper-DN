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
        e8.text = "Easy: \(boardArray[0].times[0] / 60) min, \(boardArray[0].times[0] % 60) sec"
        e10.text = "Easy: \(boardArray[0].times[1] / 60) min, \(boardArray[0].times[1] % 60) sec"
        e12.text = "Easy: \(boardArray[0].times[2] / 60) min, \(boardArray[0].times[2] % 60) sec"
        m8.text = "Medium: \(boardArray[1].times[0] / 60) min, \(boardArray[1].times[0] % 60) sec"
        m10.text = "Medium: \(boardArray[1].times[1] / 60) min, \(boardArray[1].times[1] % 60) sec"
        m12.text = "Medium: \(boardArray[1].times[2] / 60) min, \(boardArray[1].times[2] % 60) sec"
        h8.text = "Hard: \(boardArray[2].times[0] / 60) min, \(boardArray[2].times[0] % 60) sec"
        h10.text = "Hard: \(boardArray[2].times[1] / 60) min, \(boardArray[2].times[1] % 60) sec"
        h12.text = "Hard: \(boardArray[2].times[2] / 60) min, \(boardArray[2].times[2] % 60) sec"
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
