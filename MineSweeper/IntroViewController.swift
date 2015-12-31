//
//  IntroViewController.swift
//  MineSweeperPractice
//
//  Created by Andrew Grossfeld on 11/28/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

@objc
protocol IntroViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class IntroViewController: UIViewController {
    
    @IBOutlet weak var topBarImage: UIImageView!
    @IBOutlet weak var leftBarIcon: UIButton!
    @IBOutlet weak var rightBarIcon: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleMineImage: UIImageView!
    
    var gameType: Int = 0
    var gameLevel: Int = 0
    
    var delegate: IntroViewControllerDelegate?
    var containerVC: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set shadows for top bar buttons
        for button in self.view.subviews{
            (button as? UIButton)?.layer.shadowColor = UIColor.blackColor().CGColor
            (button as? UIButton)?.layer.shadowOffset = CGSizeMake(1,1)
            (button as? UIButton)?.layer.shadowOpacity = 0.9
            (button as? UIButton)?.layer.shadowRadius = 1
        }
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        layoutTheme()
    }
    
     // Set background and text colors according to theme
    func layoutTheme() {
        self.view.backgroundColor = Style.foundationColor
        if Style.foundationColor == UIColor.blackColor(){
            topBarImage.image = UIImage(named: "nightSkyBar.png")
        }else{
            topBarImage.image = UIImage(named: "skyBar.png")
        }
        topBarImage.layer.shadowColor = UIColor.blackColor().CGColor
        topBarImage.layer.shadowOffset = CGSizeMake(0,4)
        topBarImage.layer.shadowOpacity = 0.6
        topBarImage.layer.shadowRadius = 3
        
        titleLabel.textColor = Style.textColor
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSizeMake(2,2)
        titleLabel.layer.shadowRadius = 1
    }
    
    // Button to start minesweeper game
    @IBAction func startGame (sender: UIButton) {
        let gameVC = GameViewController()
        
        gameVC.gameSize = 8 + 2*gameType
        gameVC.gameLevel = gameLevel
        gameVC.introVC = self as IntroViewController
        containerVC?.currentState = .GameSimulation
        self.navigationController?.pushViewController(gameVC, animated: true)
        
    }
    
    @IBAction func sideTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    @IBAction func scoreTapped(sender: UIButton) {
        delegate?.toggleRightPanel?()
    }
}
