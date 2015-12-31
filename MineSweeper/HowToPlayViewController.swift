//
//  HowToPlayViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/21/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
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
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var leftMine: UIImageView!
    @IBOutlet weak var rightMine: UIImageView!
 
    override func viewWillAppear(animated: Bool) {
        let views = [topL, topM, topR, left, right, botL, botM, botR]
        for view in views {
            view.backgroundColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 0.8)
            let image1:UIImage = UIImage(named: "landmine")!
            let image2:UIImage = UIImage(named: "qmark")!
            view.image = image1
            view.animationImages = [image1, image2]
            view.animationDuration = 2.0
            view.animationRepeatCount = 0
            view.startAnimating()
        }
        
        layoutTheme()
    }
    
    func layoutTheme() { // set background and text colors according to theme
        self.view.backgroundColor = Style.foundationColor
        
        for view in self.view.subviews {
            (view as? UILabel)?.textColor = Style.textColor
        }
    }

    @IBAction func returnToRoot(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func howToButton(sender: UIButton) {
        if first.hidden == true{
            first.hidden = false
            second.hidden = false
            third.hidden = false
            leftMine.hidden = false
            rightMine.hidden = false
        }else{
            first.hidden = true
            second.hidden = true
            third.hidden = true
            leftMine.hidden = true
            rightMine.hidden = true
        }
    }
}
