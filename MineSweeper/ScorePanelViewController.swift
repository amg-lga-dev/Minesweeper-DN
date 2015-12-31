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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var instructionsButton: UIButton!
    
    var board: Int = 0
    var level: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
        instructionsButton.layer.shadowOpacity = 0.7
        instructionsButton.layer.shadowOffset = CGSizeMake(4, 4)
        instructionsButton.layer.shadowRadius = 4
        instructionsButton.layer.shadowColor = UIColor.blackColor().CGColor
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
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOffset = CGSizeMake(2,2)
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
    }
    @IBAction func showHTPVC(sender: UIButton) {
        let htpvc = HowToPlayViewController()
        presentViewController(htpvc, animated: true, completion: nil)
    }

}
