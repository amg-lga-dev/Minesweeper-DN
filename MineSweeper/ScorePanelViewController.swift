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
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var boardSeg: UISegmentedControl!
    @IBOutlet weak var levelSeg: UISegmentedControl!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if theme == "Day"{
            setToDay()
        }else{
            setToNight()
        }
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
    }
    
    func setToDay(){
        backgroundImage.image = UIImage(named: "sky")
        bottomImage.layer.opacity = 1
        titleLabel.textColor = UIColor.blackColor()
        boardLabel.textColor = UIColor.blackColor()
        levelLabel.textColor = UIColor.blackColor()
        boardSeg.tintColor = UIColor.blackColor()
        levelSeg.tintColor = UIColor.blackColor()
    }
    
    func setToNight(){
        backgroundImage.image = UIImage(named: "nightSky")
        bottomImage.layer.opacity = 0.7
        titleLabel.textColor = UIColor.whiteColor()
        boardLabel.textColor = UIColor.whiteColor()
        levelLabel.textColor = UIColor.whiteColor()
        boardSeg.tintColor = UIColor.whiteColor()
        levelSeg.tintColor = UIColor.whiteColor()
    }

}
