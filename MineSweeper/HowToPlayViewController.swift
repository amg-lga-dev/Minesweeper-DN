//
//  HowToPlayViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 12/21/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {
    @IBOutlet weak var topR: UIImageView!
    @IBOutlet weak var topM: UIImageView!
    @IBOutlet weak var topL: UIImageView!
    @IBOutlet weak var left: UIImageView!
    @IBOutlet weak var right: UIImageView!
    @IBOutlet weak var botL: UIImageView!
    @IBOutlet weak var botM: UIImageView!
    @IBOutlet weak var botR: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let views = [topL, topM, topR, left, right, botL, botM, botR]
        for view in views {
            view.backgroundColor = UIColor(red: 255/255, green: 251/255, blue: 80/255, alpha: 0.8)
            let image1:UIImage = UIImage(named: "landmine")!
            let image2:UIImage = UIImage(named: "qmark")!
            view.image = image1
            view.animationImages = [image1, image2]
            view.animationDuration = 2.0
            view.animationRepeatCount = 0
            view.startAnimating()
        }
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
