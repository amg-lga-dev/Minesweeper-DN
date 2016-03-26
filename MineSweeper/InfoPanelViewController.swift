//
//  ScorePanelViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/29/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

class InfoPanelViewController: UIViewController, Dimmable{
    
    var introVC: IntroViewController?

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionBorderView: UIView!
    
    @IBOutlet weak var instructionsButton: UIButton!
    
    var board: Int = 0
    var level: Int = 0
    let dimLevel: CGFloat = 0.7
    let dimSpeed: Double = 0.5
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
    }
    
    // Set theme depending on Day or Night
    func setTheme(theme: String){
        if theme == "Day"{
            backgroundImage.image = UIImage(named: "sky")
            bottomImage.layer.opacity = 1.0
        }else{
            backgroundImage.image = UIImage(named: "nightSky")
            bottomImage.layer.opacity = 0.9
        }
        bottomImage.layer.shadowColor = UIColor.blackColor().CGColor
        bottomImage.layer.shadowOffset = CGSizeMake(3, 2)
        bottomImage.layer.shadowOpacity = 0.6
        bottomImage.layer.shadowRadius = 2
        
        captionBorderView.backgroundColor = UIColor.clearColor()
        captionBorderView.layer.borderColor = UIColor.whiteColor().CGColor
        captionBorderView.layer.borderWidth = 1
        
        for label in self.view.subviews{
            (label as? UILabel)?.textColor = Style.textColor
        }
        // Set title's color and shadow
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOffset = CGSizeMake(2,2)
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
        
        // Set instruction button's shadow
        instructionsButton.layer.shadowColor = UIColor.blackColor().CGColor
        instructionsButton.layer.shadowOffset = CGSizeMake(2, 4)
        instructionsButton.layer.shadowOpacity = 0.7
        instructionsButton.layer.shadowRadius = 4
    }

    @IBAction func showHTPVC(sender: UIButton) {
        //let htpvc = HowToPlayViewController()
        //presentViewController(htpvc, animated: true, completion: nil)
        let vc = PopViewController()
        vc.selectedContent = "Step 1"
        vc.parentVC = self
        vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        dim(.In, alpha: dimLevel, speed: dimSpeed)
        if (self.introVC != nil) {
            introVC?.dim(.In, alpha: dimLevel, speed: dimSpeed)
            vc.introVC = introVC
        }
        presentViewController(vc, animated: true, completion: nil)
    }

}
