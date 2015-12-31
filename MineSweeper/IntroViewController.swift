//
//  IntroViewController.swift
//  MineSweeperPractice
//
//  Created by Andrew Grossfeld & Logan Allen on 11/28/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
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
    @IBOutlet weak var mainMineImage: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var gameType: Int = 0
    var gameLevel: Int = 0
    
    var delegate: IntroViewControllerDelegate?
    var containerVC: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set shadows for top bar buttons
        for button in self.view.subviews{
            (button as? UIButton)?.layer.shadowColor = UIColor.blackColor().CGColor
            (button as? UIButton)?.layer.shadowOffset = CGSizeMake(2,1)
            (button as? UIButton)?.layer.shadowOpacity = 0.9
            (button as? UIButton)?.layer.shadowRadius = 1
        }
        topBarImage.layer.shadowOffset = CGSizeMake(0,4)
        topBarImage.layer.shadowOpacity = 0.6
        topBarImage.layer.shadowRadius = 4
        
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSizeMake(2,1)
        titleLabel.layer.shadowRadius = 1
        
        startButton.layer.shadowOffset = CGSizeMake(4,4)
        startButton.layer.shadowOpacity = 0.6
        startButton.layer.shadowRadius = 4
        
        titleMineImage.layer.shadowOffset = CGSizeMake(2,2)
        titleMineImage.layer.shadowOpacity = 0.6
        titleMineImage.layer.shadowRadius = 2
        mainMineImage.layer.shadowOffset = CGSizeMake(3,3)
        mainMineImage.layer.shadowOpacity = 0.6
        mainMineImage.layer.shadowRadius = 2
        
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
            topBarImage.layer.shadowColor = UIColor.whiteColor().CGColor
            startButton.setBackgroundImage(UIImage(named: "nightSkyBar.png"), forState: .Normal)
            startButton.layer.shadowColor = UIColor.whiteColor().CGColor
            titleMineImage.layer.shadowColor = UIColor.whiteColor().CGColor
            mainMineImage.layer.shadowColor = UIColor.whiteColor().CGColor
        }else{
            topBarImage.image = UIImage(named: "skyBar.png")
            topBarImage.layer.shadowColor = UIColor.blackColor().CGColor
            startButton.setBackgroundImage(UIImage(named: "skyBar.png"), forState: .Normal)
            startButton.layer.shadowColor = UIColor.blackColor().CGColor
            titleMineImage.layer.shadowColor = UIColor.blackColor().CGColor
            mainMineImage.layer.shadowColor = UIColor.blackColor().CGColor
        }
        titleLabel.textColor = Style.textColor
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
